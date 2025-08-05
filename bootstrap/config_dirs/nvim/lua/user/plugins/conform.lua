-- https://www.josean.com/posts/neovim-linting-and-formatting
return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				bash = { "beautysh" },
				css = { "prettierd" },
				graphql = { "prettierd" },
				html = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				python = { "isort", "black" },
				sh = { "beautysh" },
				swift = { "swiftformat" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				yaml = { "prettierd", "yamlfmt" },
				zsh = { "shfmt" },
			},
			-- formatters = {
			-- 	stylua = {
			-- 		command = "stylua",
			-- 		args = {
			-- 			"--indent-type", "Spaces",    -- Use spaces for indentation
			-- 			"--indent-width", "4",        -- Set indent width to 4 spaces
			-- 			"--quote-style", "AutoPreferSingle",  -- Prefer single quotes
			-- 			"--column-width", "300", -- Set maximum column width to 100
			-- 		},
			-- 	},
			-- },
			format_on_save = {
				lsp_fallback = true,
				async = false,
				-- timeout_ms = 500,
				timeout_ms = 3000,
			},
		})

		-- how-to: https://github.com/stevearc/conform.nvim#customizing-formatters
		-- conform.formatters.stylua = {
		-- 	env = {
		-- 		"--column_width",
		-- 		"300",
		-- 	},
		-- }

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				-- timeout_ms = 500,
				timeout_ms = 3000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
