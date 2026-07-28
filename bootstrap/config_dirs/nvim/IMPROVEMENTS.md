# Neovim config improvements

Audit of this config against Neovim **0.12.1**, done 2026-07-28. Every claim below
was verified against the installed runtime and plugins, not assumed. Line numbers
were accurate at the time of writing.

The theme: nvim 0.11/0.12 absorbed a lot of what this config hand-rolls, and a few
plugin specs have quietly stopped doing anything.

---

## Done

- [x] **which-key group labels** for all 14 `<leader>` prefixes — `lua/plugins/which-key.lua`
- [x] **`<leader>hh` → `<leader>fH`** (command history off the gitsigns hunk prefix) — `lua/plugins/telescope.lua`
- [x] **Removed Comment.nvim** + `nvim-ts-context-commentstring` — deleted `lua/plugins/comment.lua`
- [x] **Options added** — `confirm`, `updatetime=250`, `jumpoptions=stack` in `lua/core/options.lua`

### Follow-up from the Comment.nvim removal

Built-in `gc` covers it, including JSX context (verified: `{/* %s */}` inside a
`jsx_element`, `// %s` in plain TS). The query metadata that makes this work is at
`~/.local/share/nvim/site/queries/jsx/highlights.scm`, installed by nvim-treesitter's
`main` branch; `tsx` and `javascript` both `; inherits: jsx`.

Gained: `gc` as a **text object** — `gcgc` uncomments a block, `dgc` deletes one.
Comment.nvim was shadowing this.

Lost, now unmapped: `gco`, `gcO`, `gcA`, `gb`, `gbc`. First three are cheap natively:

```lua
-- lua/core/keymaps.lua
keymap.set("n", "gco", "o<C-o>gcc", { remap = true, desc = "Comment line below" })
keymap.set("n", "gcO", "O<C-o>gcc", { remap = true, desc = "Comment line above" })
keymap.set("n", "gcA", "<End>a<C-o>gcc", { remap = true, desc = "Comment at end of line" })
```

`gb` (blockwise `/* */` operator) has no one-line equivalent — the only real capability loss.

**Still to do:** run `:Lazy clean` to uninstall the two plugins and prune `lazy-lock.json`.

---

## Pending — broken or fighting itself

### 1. Two completion engines running at once

`lua/core/autocmds.lua:42-43`

`vim.lsp.completion.enable(..., { autotrigger = true })` fires on every `LspAttach`
while **nvim-cmp is also enabled**. Both drive the popup. Line 42 additionally sets
`completeopt` with `vim.opt` (global) rather than `vim.bo`, so it clobbers cmp's own
`completeopt` for every buffer.

Pick one. Given LuaSnip + lspkind + friendly-snippets are all wired into cmp, dropping
the native block is the smaller change.

### 2. `<leader>lA` throws on invocation

`lua/core/autocmds.lua:20` → `vim.lsp.buf.range_code_action`

Removed from Neovim years ago; confirmed absent from the 0.12.1 runtime. Delete the
mapping — `vim.lsp.buf.code_action` already handles visual ranges, so `<leader>la`
in visual mode covers the use case.

### 3. `vim-ReplaceWithRegister` steals `grr`, and is itself broken

`lua/plugins/init.lua:3`

The plugin sets `nmap gr` (operator) and `nmap grr` (line). Verified resolution:

| Key | Resolves to | |
|---|---|---|
| `grr` | `<Plug>ReplaceWithRegisterLine` | ⚠ LSP references shadowed |
| `gr` | `<Plug>ReplaceWithRegisterOperator` | |
| `grn` `gra` `gri` `grt` | rename / code_action / implementation / type_definition | ✓ LSP intact |

So the LSP defaults mostly survive — only `grr` is lost. But the plugin's own operator
is unusable for the common text objects, because `griw`, `graw`, `grip` all match
`gri`/`gra` first.

It's also fully redundant: **substitute.nvim on `s` already does this** (`siw`, `ss`, `S`,
visual `s`). Delete the plugin and `grr` comes back.

### 4. Double `nvim-treesitter-textobjects` setup — silently kills your jumplist

`lua/plugins/nvim-treesitter.lua:84-93` vs `lua/plugins/nvim-treesitter-text-objects.lua:33`

`setup()` is called twice with conflicting options. Because textobjects is declared a
dependency of nvim-treesitter it loads *first* (registering all keymaps with
`set_jumps = true`), then nvim-treesitter's config calls `setup()` again with
`set_jumps = false` and no keymaps — and that one wins.

Net effect: `]m` / `[m` / `]c` / `]f` no longer push to the jumplist, so `<C-o>` won't
bring you back. **Fix: delete the block at `nvim-treesitter.lua:84-93`.**

### 5. Two plugins loading for nothing

- **leap.nvim** (`lua/plugins/leap.lua`) — its `config` requires leap then does nothing.
  No `set_default_mappings()`, `keys` commented out. Zero mappings exist. And `s`/`S`/`gs`
  are taken by substitute.nvim and the LspAttach handler anyway. Either remove it or give
  it non-conflicting keys.
- **lspsaga.nvim** (`lua/plugins/lspsaga.lua:3`) — says `enable = true`, but lazy.nvim's
  key is `enabled`, so that line is a no-op. More to the point there are no Lspsaga
  keymaps or commands anywhere in the config, so it loads and overrides handlers for
  no benefit.

### 6. Dashboard keys `a` and `d` error

`lua/plugins/dashboard.lua` — they call `Telescope app` and `Telescope dotfiles`, but
only the `fzf` and `nerdy` extensions are loaded (`telescope.lua` `config`).

### 7. `<leader>sm` defined twice

`lua/core/keymaps.lua:54` and `lua/plugins/vim-maximizer.lua:4`. Same command, so
harmless — but the eager one in `keymaps.lua` defeats vim-maximizer's lazy-loading.

---

## Pending — redundant with nvim 0.12 defaults

All confirmed present at runtime (`:h default-mappings`):

| Your mapping | Built-in equivalent |
|---|---|
| `<leader>bn` / `<leader>bp` | `]b` / `[b` |
| `<leader>rw` | `siw` (substitute.nvim, register preserved) |
| — (never mapped) | `]q` `[q` `]Q` `[Q` quickfix — you send results there with telescope `<C-q>` but never navigate |
| — | `]d` `[d` diagnostics, `]l` `[l` loclist, `]a` `[a` args, `]t` `[t` tags |
| — | `K` hover, `<C-s>` signature help (insert), `gO` document symbols |

Also: **`an` / `in` in visual mode** = treesitter node selection, built in. You disabled
`incremental_selection` in `nvim-treesitter.lua` over a `<C-i>` conflict — the native
version has no such conflict.

**Deprecated API:** gitsigns `next_hunk` / `prev_hunk` (`lua/plugins/gitsigns.lua`) are
marked `@deprecated` in the installed version → use `nav_hunk("next")` / `nav_hunk("prev")`.
`undo_stage_hunk` still exists and is fine.

---

## Pending — wins not yet taken

1. **`:Telescope resume`** — the single biggest one, and there's no mapping for it.
   Reopens the last picker with query and cursor position intact; invaluable when you
   grep, jump to a result, then want the next. Suggest `<leader>f.` or `<leader>fR`.
2. **`<C-^>`** toggles the alternate file — faster than `<leader>fb` for ping-ponging
   between two files.
3. **Underused and already configured:** the treesitter textobjects in
   `nvim-treesitter-text-objects.lua` are genuinely good — `a=` `i=` `l=` `r=` for
   assignment sides, `aa`/`ia` arguments, `ai`/`ii` conditionals, and `<leader>na` /
   `<leader>pa` to swap arguments. `r=` (change just the right-hand side) is worth
   the muscle memory. Fix #4 above first so the jumps work properly.

### which-key label cleanup

Two group labels are awkward because the namespaces are mixed:

- `<leader>n` = "swap w/ next + nohl" — `nh` clears highlights, `n{a,m,:}` swap
- `<leader>r` = "replace + restart lsp" — `rw` replaces word, `rs` restarts LSP

Moving `<leader>nh` elsewhere and dropping `<leader>rw` (redundant per above) would make
both read as single-purpose groups.
