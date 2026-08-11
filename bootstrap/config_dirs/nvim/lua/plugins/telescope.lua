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
		-- { "<leader>ff", ":Telescope find_files<CR>", desc = "Fuzzy find files in cwd" }, -- find files within current working directory, respects .gitignore
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({
					find_command = {
						"fd",
						".",
						vim.fn.getcwd(),
						"--type",
						"f",
						"--hidden",
						"--exclude",
						".git",
						"--exclude",
						"node_modules",
					},
				})
			end,
			desc = "Fuzzy find files in cwd",
		},
		{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
		{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" }, -- find string under cursor in current working directory
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "List open buffers" },
		{ "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Open jumplist" },
		{ "<leader>fp", "<cmd>Telescope builtin<cr>", desc = "List Builtin Pickers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "List Help Tags" },

		-- Keymaps
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "List Keymaps" },

		-- ToDo Comment
		{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" }, -- find todos in cwd

		-- Git
		{ "<leader>gC", "<cmd>Telescope git_commits<cr>", desc = "All Commits" }, -- use <cr> to checkout ["gc" for git commits]
		{ "<leader>gh", "<cmd>Telescope git_bcommits<cr>", desc = "File History" }, -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" }, -- list git branches (use <cr> to checkout) ["gb" for git branch]
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },

		-- Commands
		{ "<leader>fH", "<cmd>Telescope command_history<cr>", desc = "Command history" },
		{ "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
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
