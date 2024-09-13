return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed, not both.
		"nvim-telescope/telescope.nvim", -- optional
		-- "ibhagwan/fzf-lua", -- optional
	},
	cmd = {
		"Neogit",
	},
	keys = {
		{ "<leader>gg", ":Neogit<CR>", desc = "Neogit" },
		{ "<leader>gc", ":Neogit commit<CR>", desc = "Neogit commit" },
		{ "<leader>gl", ":Neogit pull<CR>", desc = "Neogit pull" },
		{ "<leader>gp", ":Neogit push<CR>", desc = "Neogit push" },
		-- { "<leader>gB", ":Git blame<CR>", desc = "Git Blame" },
	},
	opts = {},
}
