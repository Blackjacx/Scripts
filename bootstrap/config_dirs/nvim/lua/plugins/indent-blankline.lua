-- Adds indentation guides to Neovim. It uses Neovim's virtual text feature and no conceal.
return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		-- indent = { char = "." },
		-- indent = { char = "┊" },
		indent = { char = "┊" },
	},
}
