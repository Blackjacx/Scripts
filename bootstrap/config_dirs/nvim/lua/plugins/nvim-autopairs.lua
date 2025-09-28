-- A super powerful autopair plugin for Neovim that supports multiple characters.
return {
	"windwp/nvim-autopairs",
	enabled = false, -- dissbled due to native integration of LPS in nvim 0.11+ (https://gpanders.com/blog/whats-new-in-neovim-0-11/#builtin-auto-completion)
	event = { "InsertEnter" },
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- import nvim-autopairs
		local autopairs = require("nvim-autopairs")

		-- configure autopairs
		autopairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
				java = false, -- don't check treesitter on java
			},
		})

		-- import nvim-autopairs completion functionality
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- import nvim-cmp plugin (completions plugin)
		local cmp = require("cmp")

		-- make autopairs and completion work together
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
