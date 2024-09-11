return {
	"nvim-telescope/telescope.nvim",
	-- branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("nerdy")

		-- Keymaps

		local keymap = vim.keymap

		-- Files
		keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Fuzzy find files in cwd" }) -- find files within current working directory, respects .gitignore
		keymap.set("n", "<leader>fs", ":Telescope live_grep<CR>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", ":Telescope grep_string<CR>", { desc = "Find string under cursor in cwd" }) -- find string under cursor in current working directory
		keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "List open buffers" })
		keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "List Help Tags" })

		-- ToDo Comment
		keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find todos" }) -- find todos in cwd

		-- Git
		keymap.set("n", "<leader>gC", ":Telescope git_commits<CR>", { desc = "All Commits" }) -- use <cr> to checkout ["gc" for git commits]
		keymap.set("n", "<leader>gh", ":Telescope git_bcommits<CR>", { desc = "File History" }) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
		keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Git Branches" }) -- list git branches (use <cr> to checkout) ["gb" for git branch]
		keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { desc = "Git Status" })
	end,
}
