return {
	"nvim-telescope/telescope.nvim",
	-- branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	keys = {
		-- Files
		{ "<leader>ff", ":Telescope find_files<CR>", desc = "Fuzzy find files in cwd" }, -- find files within current working directory, respects .gitignore
		{ "<leader>fs", ":Telescope live_grep<CR>", desc = "Find string in cwd" },
		{ "<leader>fc", ":Telescope grep_string<CR>", desc = "Find string under cursor in cwd" }, -- find string under cursor in current working directory
		{ "<leader>fr", ":Telescope oldfiles<CR>", desc = "Fuzzy find recent files" },
		{ "<leader>fb", ":Telescope buffers<CR>", desc = "List open buffers" },
		{ "<leader>fj", ":Telescope jumplist<CR>", desc = "Open jumplist" },
		{ "<leader>fh", ":Telescope help_tags<CR>", desc = "List Help Tags" },

		-- ToDo Comment
		{ "<leader>ft", ":TodoTelescope<CR>", desc = "Find todos" }, -- find todos in cwd

		-- Git
		{ "<leader>gC", ":Telescope git_commits<CR>", desc = "All Commits" }, -- use <cr> to checkout ["gc" for git commits]
		{ "<leader>gh", ":Telescope git_bcommits<CR>", desc = "File History" }, -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
		{ "<leader>gb", ":Telescope git_branches<CR>", desc = "Git Branches" }, -- list git branches (use <cr> to checkout) ["gb" for git branch]
		{ "<leader>gs", ":Telescope git_status<CR>", desc = "Git Status" },
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
	end,
}
