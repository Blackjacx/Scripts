return {
	-- "ellisonleao/gruvbox.nvim",
	"sainnhe/gruvbox-material",
	-- "folke/tokyonight.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme gruvbox-material]])
		-- vim.cmd([[colorscheme tokyonight]])
	end,
}
