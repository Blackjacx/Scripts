-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.

return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason_tool_installer
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"actionlint", -- linter for GH actions
				"beautysh", -- shell formatter
				"black", -- python formatter
				"commitlint", -- commit linter
				"cspell", -- spell checker for code
				"eslint_d", -- js linter
				"isort", -- python formatter
				"jsonlint", -- json linter
				"latexindent", -- latex formatter
				-- "luacheck", -- lua linter 🚨 currently issues during install
				"prettier", -- formatter for angular, css, flow, graphql, html, json, jsx, javascript, less, markdown, scss, typescript, vue, yaml
				"prettierd", -- formatter for angular, css, flow, graphql, html, json, jsx, javascript, less, markdown, scss, typescript, vue, yaml
				"proselint", -- formatter for prose text
				"pylint", -- python linter
				"shellcheck", -- bash linter
				"shfmt", -- shell formatter
				"stylua", -- lua formatter
				"swiftlint", -- swift linter
				"yamlfmt", -- yaml formatter
			},
		})
	end,
}
