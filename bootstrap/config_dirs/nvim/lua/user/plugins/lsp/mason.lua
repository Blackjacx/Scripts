-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

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

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"bashls",
				"cssls",
				"dockerls",
				"emmet_ls",
				"graphql",
				"html",
				"kotlin_language_server",
				"lua_ls",
				"marksman",
				"pyright",
				"ruby_lsp",
				"sourcekit-lsp",
				"tailwindcss",
				"taplo",
				"terraformls",
				"tsserver",
				"yamlls",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
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
				"prettier", -- prettier formatter
				"pylint", -- python linter
				"shellcheck", -- bash linter
				"shfmt", -- shell formatter
				"stylua", -- lua formatter
				"swiftlint", -- swift linter
			},
		})
	end,
}
