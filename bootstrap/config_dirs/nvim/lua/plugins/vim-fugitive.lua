-- Fugitive is the premier Vim plugin for Git.
-- It integrates Git commands directly into the Vim text editor.
return {
	"tpope/vim-fugitive",
	dependencies = {
		"tpope/vim-rhubarb",
	},
	keys = {
		{ "<leader>gy", "<CMD>GBrowse<CR>", desc = "Open current file in web" },
		{ "<leader>gY", "<CMD>.GBrowse<CR>", desc = "Open current line in web" },
	},
	event = { "BufReadPre", "BufNewFile" },
}
