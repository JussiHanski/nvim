local Buf = require('lazydev.buf')
local Config = require('lazydev.config')
local Pkg = require('lazydev.pkg')

local CompletionItemKind = require('blink.cmp.types').CompletionItemKind

local Source = {}
Source.__index = Source

function Source.new(opts, _)
  local self = setmetatable({}, Source)
  self.opts = opts or {}
  return self
end

function Source:enabled()
  local buf = vim.api.nvim_get_current_buf()
  return Buf.attached[buf] ~= nil
end

function Source:get_trigger_characters()
  return { '"', "'", '.', '/' }
end

local function add_documentation(item, plugin)
  if not plugin or plugin == '' then
    return
  end

  if item.documentation and item.documentation.kind == 'markdown' then
    if not item.documentation.value:find(plugin, 1, true) then
      item.documentation.value = item.documentation.value .. '\n- `' .. plugin .. '`'
    end
    return
  end

  item.documentation = {
    kind = 'markdown',
    value = '# Plugins:\n- `' .. plugin .. '`',
  }
end

function Source:get_completions(context, callback)
  local before = context.line:sub(1, context.cursor[2])
  local req, forward_slash = Pkg.get_module(before, { before = true })
  if not req then
    return callback({
      is_incomplete_forward = false,
      is_incomplete_backward = false,
      items = {},
    })
  end

  local seen = {}
  local items = {}

  local function add(modname, modpath)
    if not modname then
      return
    end

    local label = forward_slash and modname:gsub('%.', '/') or modname

    local item = seen[label]
    if not item then
      item = {
        label = label,
        insertText = label,
        filterText = label,
        sortText = label,
        kind = CompletionItemKind.Module,
      }
      seen[label] = item
      table.insert(items, item)
    end

    add_documentation(item, Pkg.get_plugin_name(modpath or ''))
  end

  if not req:find('.', 1, true) then
    Pkg.topmods(add)
    for _, lib in ipairs(Config.libs) do
      for _, mod in ipairs(lib.mods) do
        add(mod, lib.path)
      end
    end
  else
    local prefix = req:gsub('%.[^%.]*$', '')
    Pkg.lsmod(prefix, add)
  end

  local start_col = context.bounds.start_col - 1
  local finish_col = start_col + context.bounds.length
  local line = context.cursor[1] - 1

  for _, item in ipairs(items) do
    local text = item.insertText or item.label
    item.textEdit = {
      newText = text,
      range = {
        start = { line = line, character = start_col },
        ['end'] = { line = line, character = finish_col },
      },
    }
  end

  callback({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
  })
end

return {
  new = function(opts, provider_config)
    return Source.new(opts, provider_config)
  end,
}

