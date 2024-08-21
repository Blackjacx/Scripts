-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- exit insert mode with jk
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x', { desc = "Delete single character without copying into register" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" }) -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", ":Telescope live_grep<CR>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>", { desc = "Find string under cursor in cwd" }) -- find string under cursor in current working directory
keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "list open buffers in current neovim instance" })
keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "List Help Tags" })
keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find todos" }) -- find todos in cwd

-- Telescope Git
keymap.set("n", "<leader>gC", ":Telescope git_commits<CR>", { desc = "All Commits" }) -- use <cr> to checkout ["gc" for git commits]
keymap.set("n", "<leader>gh", ":Telescope git_bcommits<CR>", { desc = "File History" }) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Git Branches" }) -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { desc = "Git Status" })

-- Neogit
keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Neogit" })
keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { desc = "Neogit commit" })
keymap.set("n", "<leader>gl", ":Neogit pull<CR>", { desc = "Neogit pull" })
keymap.set("n", "<leader>gp", ":Neogit push<CR>", { desc = "Neogit push" })
-- keymap.set("n", "<leader>gB", ":Git blame<CR>", { desc = "Git Blame" })

-- GitSigns
-- keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview current hunk" })
-- keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git Toggle Line Blame" })
keymap.set("n", "<leader>gB", ":Gitsigns blame<CR>", { desc = "Git Blame" })

-- Vim Fugitive (Git)

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart lsp server" })
