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
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Open tree on current file" })
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

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
