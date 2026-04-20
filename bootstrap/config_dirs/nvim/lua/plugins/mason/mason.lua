-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.

return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"bashls",
				"emmet_ls",
				"gopls",
				"graphql",
				"kotlin_language_server",
				"lua_ls",
				"marksman", -- we use tailwindcss
				"pyright",
				"rubocop",
				-- "sourcekit", -- installed manually
				"taplo",
				"terraformls",
				"texlab",
				"yamlls",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
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
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
