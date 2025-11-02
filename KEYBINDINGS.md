# Neovim Keybindings Cheatsheet

Quick reference for all configured keybindings. Press `<leader>?` to open this cheatsheet.

**Leader key**: `Space`

---

## Core Vim Navigation

| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left, Down, Up, Right |
| `w` `b` | Next word, Previous word |
| `0` `$` | Start of line, End of line |
| `gg` `G` | Top of file, Bottom of file |
| `{` `}` | Previous paragraph, Next paragraph |
| `Ctrl-u` `Ctrl-d` | Scroll up half page, Scroll down half page |
| `Ctrl-b` `Ctrl-f` | Scroll up full page, Scroll down full page |
| `%` | Jump to matching bracket |
| `*` `#` | Search word under cursor (forward/backward) |

## Core Vim Editing

| Key | Action |
|-----|--------|
| `i` `a` | Insert before cursor, Insert after cursor |
| `I` `A` | Insert at line start, Insert at line end |
| `o` `O` | New line below, New line above |
| `x` `X` | Delete char, Delete char before |
| `dd` | Delete line |
| `D` | Delete to end of line |
| `yy` `Y` | Copy line |
| `p` `P` | Paste after, Paste before |
| `u` | Undo |
| `Ctrl-r` | Redo |
| `.` | Repeat last change |
| `>>` `<<` | Indent right, Indent left |
| `==` | Auto-indent line |
| `J` | Join line below |

## Window Management

| Key | Action |
|-----|--------|
| `Ctrl-h` | Move to left window |
| `Ctrl-j` | Move to window below |
| `Ctrl-k` | Move to window above |
| `Ctrl-l` | Move to right window |
| `Ctrl-w s` | Split horizontal |
| `Ctrl-w v` | Split vertical |
| `Ctrl-w q` | Close window |
| `Ctrl-w o` | Close all other windows |

## File Operations

| Key | Action |
|-----|--------|
| `:w` | Write (save) file |
| `:q` | Quit |
| `:wq` | Write and quit |
| `:q!` | Quit without saving |
| `Esc` | Clear search highlight |

---

## Telescope - Fuzzy Finder

| Key | Action |
|-----|--------|
| `<leader>sf` | [S]earch [F]iles |
| `<leader>sg` | [S]earch by [G]rep |
| `<leader>sw` | [S]earch current [W]ord |
| `<leader>sd` | [S]earch [D]iagnostics |
| `<leader>sr` | [S]earch [R]esume |
| `<leader>s.` | [S]earch Recent Files |
| `<leader>sb` | [S]earch [B]uffers |
| `<leader>sh` | [S]earch [H]elp |
| `<leader>sk` | [S]earch [K]eymaps |
| `<leader>ss` | [S]earch [S]elect Telescope |
| `<leader>/` | Search in current buffer |
| `<leader><leader>` | Find existing buffers |

### Inside Telescope

| Key | Action |
|-----|--------|
| `Ctrl-n` `Ctrl-p` | Next/Previous result |
| `Ctrl-u` `Ctrl-d` | Scroll preview up/down |
| `Enter` | Select item |
| `Esc` | Close |

---

## LSP - Language Server

| Key | Action |
|-----|--------|
| `gd` | [G]oto [D]efinition |
| `gr` | [G]oto [R]eferences |
| `gI` | [G]oto [I]mplementation |
| `gy` | [G]oto T[y]pe Definition |
| `gD` | [G]oto [D]eclaration |
| `<leader>ds` | [D]ocument [S]ymbols |
| `<leader>ws` | [W]orkspace [S]ymbols |
| `<leader>rn` | [R]e[n]ame |
| `<leader>ca` | [C]ode [A]ction |
| `<leader>D` | Type [D]efinition |
| `K` | Hover Documentation |
| `Ctrl-k` | Signature Help (insert mode) |

### Diagnostics

| Key | Action |
|-----|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Show diagnostic error messages |
| `<leader>q` | Open diagnostic quickfix list |

---

## Git - Gitsigns

### Navigation

| Key | Action |
|-----|--------|
| `]h` | Next [H]unk |
| `[h` | Previous [H]unk |

### Hunk Actions

| Key | Action |
|-----|--------|
| `<leader>hs` | [H]unk [S]tage |
| `<leader>hr` | [H]unk [R]eset |
| `<leader>hp` | [H]unk [P]review |
| `<leader>hb` | [H]unk [B]lame line |
| `<leader>hB` | [H]unk [B]lame buffer (full file) |
| `<leader>hu` | [H]unk [U]ndo stage |
| `<leader>hS` | [H]unk [S]tage buffer |
| `<leader>hR` | [H]unk [R]eset buffer |
| `<leader>hd` | [H]unk [D]iff this |

### Toggles

| Key | Action |
|-----|--------|
| `<leader>tb` | [T]oggle git [B]lame (inline) |
| `<leader>td` | [T]oggle [D]eleted lines |

### Visual Mode

| Key | Action |
|-----|--------|
| `<leader>hs` | [H]unk [S]tage (selection) |
| `<leader>hr` | [H]unk [R]eset (selection) |

### Text Object

| Key | Action |
|-----|--------|
| `ih` | Select hunk (operator/visual mode) |

---

## Git - Diffview

| Key | Action |
|-----|--------|
| `<leader>dv` | [D]iff [V]iew open |
| `<leader>dc` | [D]iff [V]iew [C]lose |
| `<leader>dh` | [D]iff [H]istory (current file) |
| `<leader>dH` | [D]iff [H]istory (all files) |

### Inside Diffview

| Key | Action |
|-----|--------|
| `Tab` `Shift-Tab` | Next/Previous file |
| `<leader>e` | Focus file panel |
| `<leader>b` | Toggle file panel |
| `gf` | Open file in editor |
| `q` | Close diffview |

### File Panel

| Key | Action |
|-----|--------|
| `j` `k` | Navigate files |
| `Enter` | Open diff |
| `-` | Stage/unstage toggle |
| `S` | Stage all |
| `U` | Unstage all |
| `R` | Refresh |

### Merge Conflicts

| Key | Action |
|-----|--------|
| `]x` `[x` | Next/Previous conflict |
| `<leader>co` | Choose ours |
| `<leader>ct` | Choose theirs |
| `<leader>cb` | Choose both |
| `<leader>cB` | Choose base |

---

## Git - Lazygit

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazy[G]it |
| `<leader>gf` | Lazy[G]it current [F]ile |
| `<leader>gc` | Lazy[G]it [C]ommit log |

See `LAZYGIT.md` for lazygit keybindings.

---

## File Explorer - Neo-tree

| Key | Action |
|-----|--------|
| `<leader>e` | Open file [E]xplorer |
| `<leader>be` | Open [B]uffer [E]xplorer |
| `<leader>ge` | Open [G]it status [E]xplorer |

### Inside Neo-tree

| Key | Action |
|-----|--------|
| `Enter` `Space` | Open file/Expand folder |
| `a` | Add file |
| `A` | Add directory |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` `x` `p` | Copy/Cut/Paste (clipboard) |
| `H` | Toggle hidden files |
| `/` | Fuzzy finder |
| `<BS>` | Navigate up |
| `.` | Set as root directory |
| `q` | Close |
| `?` | Show all keybindings |

---

## File Explorer - Oil

| Key | Action |
|-----|--------|
| `-` | Open parent directory (oil) |
| `<leader>-` | Open oil in floating window |

### Inside Oil

| Key | Action |
|-----|--------|
| `Enter` | Open file/directory |
| `-` | Go to parent directory |
| `_` | Go to current working directory |
| `g?` | Show help |
| `:w` | Save changes (write) |
| `:q` | Quit without saving |

Edit files/directories like text, then `:w` to apply changes.

---

## AI Assistants

### Claude Code

| Key | Action |
|-----|--------|
| `Ctrl-\` | Toggle Claude Code terminal |

### GitHub Copilot

| Key | Action |
|-----|--------|
| `Ctrl-l` | Accept suggestion (insert mode) |
| `Ctrl-h` | Dismiss suggestion (insert mode) |
| `Ctrl-]` | Next suggestion (insert mode) |
| `Ctrl-[` | Previous suggestion (insert mode) |
| `<leader>cp` | Copilot [P]anel |
| `<leader>ct` | Copilot [T]oggle |

---

## Formatting

| Key | Action |
|-----|--------|
| `<leader>f` | [F]ormat file or selection |

Auto-formats on save.

---

## Other Plugins

### Which-key

Shows available keybindings after pressing leader key. Wait ~300ms after `<leader>` to see popup.

### Mini.ai

Enhanced text objects:
- `a` "around" - includes whitespace
- `i` "inside" - excludes whitespace

Works with: `w` (word), `s` (sentence), `p` (paragraph), `t` (tag), `b` (bracket), `q` (quote)

Examples:
- `daw` - Delete around word
- `ci"` - Change inside quotes
- `vip` - Select inside paragraph

### Todo Comments

Highlights: `TODO`, `HACK`, `WARN`, `PERF`, `NOTE`, `FIX`, `TEST`

| Key | Action |
|-----|--------|
| `]t` | Next todo comment |
| `[t` | Previous todo comment |
| `<leader>st` | [S]earch [T]odos (Telescope) |

---

## Terminal Mode

| Key | Action |
|-----|--------|
| `Esc` `Esc` | Exit terminal mode |
| `Ctrl-h/j/k/l` | Navigate to window (in terminal mode) |

---

## Help & Documentation

| Key | Action |
|-----|--------|
| `<leader>?` | Open this cheatsheet |
| `:help <topic>` | Open Neovim help |
| `<leader>sh` | [S]earch [H]elp |
