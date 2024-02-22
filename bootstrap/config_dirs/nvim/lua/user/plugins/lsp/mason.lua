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
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"bashls",
				"taplo",
				"dockerls",
				"kotlin_language_server",
				"marksman",
				"ruby_ls",
				"terraformls",
				"yamlls",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"shfmt", -- shell formatter
				"beautysh", -- shell formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
				"shellcheck", -- bash linter
				"commitlint", -- commit linter
				"cspell", -- spell checker for code
				"jsonlint", -- json linter
			},
		})
	end,
}
