# Lazygit Cheatsheet

Quick reference for common lazygit operations.

**Open lazygit**: `<leader>gg` in Neovim

---

## Navigation

| Key | Action |
|-----|--------|
| `j` `k` | Move down/up |
| `h` `l` | Previous/Next panel |
| `Tab` | Switch between panels |
| `[` `]` | Navigate tabs (Status, Files, Branches, Commits, Stash) |
| `1-5` | Jump directly to tab (1=Status, 2=Files, 3=Branches, 4=Commits, 5=Stash) |

---

## Files Panel

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage/unstage all files |
| `d` | Discard changes (delete) |
| `e` | Edit file |
| `o` | Open file in default editor |
| `i` | Ignore file (add to .gitignore) |
| `r` | Refresh files |
| `s` | Stash all changes |
| `S` | View stash options |
| `A` | Amend last commit |
| `Enter` | View file changes |

### Staging Hunks

| Key | Action |
|-----|--------|
| `Enter` | Open file (shows hunks) |
| `Space` | Stage/unstage individual hunk |
| `a` | Stage/unstage all hunks in file |

---

## Commits

| Key | Action |
|-----|--------|
| `c` | Commit staged changes |
| `A` | Amend last commit |
| `Enter` | View commit details |
| `Space` | Checkout commit |
| `d` | Delete/drop commit |
| `r` | Reword commit message |
| `e` | Edit commit (interactive rebase) |
| `p` | Pick commit (cherry-pick) |
| `F` | Create fixup commit |
| `S` | Squash commit |
| `R` | Rebase |
| `t` | Create tag |
| `C` | Copy commit (cherry-pick) |
| `v` | Paste commit (cherry-pick) |

---

## Branches

| Key | Action |
|-----|--------|
| `Space` | Checkout branch |
| `n` | Create new branch |
| `o` | Create pull request |
| `c` | Checkout by name |
| `F` | Force checkout |
| `d` | Delete branch |
| `r` | Rebase branch |
| `M` | Merge into current branch |
| `f` | Fast-forward branch |
| `g` | View reset options |
| `Enter` | View branch commits |

---

## Pull/Push

| Key | Action |
|-----|--------|
| `p` | Pull |
| `P` | Push |
| `Shift-P` | Push with force |
| `f` | Fetch |

---

## Stash

| Key | Action |
|-----|--------|
| `Space` | Apply stash |
| `g` | Pop stash (apply and delete) |
| `d` | Drop stash |
| `Enter` | View stash contents |

---

## Merge Conflicts

| Key | Action |
|-----|--------|
| `Space` | Pick hunk |
| `b` | Pick both hunks |
| `◄` `►` | Select previous/next conflict |
| `▲` `▼` | Select previous/next hunk |
| `z` | Undo |
| `e` | Edit file in editor |
| `o` | Open file |
| `M` | Open external merge tool |
| `Esc` | Exit merge mode |

---

## Common Workflows

### Stage and Commit

1. Navigate to Files panel (`2` or `[` `]`)
2. `Space` on files to stage
3. `c` to commit
4. Type commit message
5. `Enter` to confirm

### Create Branch and Push

1. `3` to go to Branches panel
2. `n` to create new branch
3. Make changes and commit
4. `P` to push

### Amend Last Commit

1. Stage your changes (`Space` on files)
2. `A` to amend
3. Edit message if needed
4. `Enter` to confirm

### Interactive Rebase

1. `4` to go to Commits panel
2. Select commit to start from
3. `e` to edit
4. `r` to reword
5. `s` to squash
6. `d` to drop

### Resolve Merge Conflicts

1. Conflicts appear in Files panel with red icon
2. `Enter` on conflicted file
3. Navigate conflicts with `◄` `►`
4. `Space` to pick hunk, `b` for both
5. `Esc` when done
6. `Space` to stage resolved file
7. `c` to commit merge

---

## Global Commands

| Key | Action |
|-----|--------|
| `?` | Toggle help panel |
| `x` | Open command menu |
| `z` | Undo |
| `Ctrl-z` | Redo |
| `+` `-` | Increase/decrease context in diffs |
| `:` | Execute custom command |
| `q` | Quit |
| `Esc` | Cancel/Go back |

---

## Tips

- Use `x` to open the command menu for more options
- Use `?` to see context-specific keybindings
- Most actions have confirmation prompts for safety
- Use `Ctrl-r` to refresh all panels
- Commits are shown with graph visualization
- Diff view supports word-level highlighting
