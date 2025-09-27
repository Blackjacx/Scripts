-- Smart and powerful comment plugin for neovim. Supports treesitter,
-- dot repeat, left-right/up-down motions, hooks, and more.
-- https://github.com/numToStr/Comment.nvim
return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	config = function()
		-- import plugin safely
		local plugin = require("Comment")

		local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

		-- enable plugin
		plugin.setup({
			-- for commenting tsx, jsx, svelte, html files
			pre_hook = ts_context_commentstring.create_pre_hook(),
		})
	end,
}
