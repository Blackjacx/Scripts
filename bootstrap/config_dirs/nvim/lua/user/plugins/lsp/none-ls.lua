return {
	"nvimtools/none-ls.nvim", -- configure formatters & linters
	lazy = true,
	-- event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
	dependencies = {
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local mason_null_ls = require("mason-null-ls")

		local null_ls = require("null-ls")

		local null_ls_utils = require("null-ls.utils")

		mason_null_ls.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"black", -- python formatter
				"shfmt", --shell formatter
				"beautysh", --shell formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
				"shellcheck", -- bash linter
				"commitlint", -- commit linter
				"cspell", -- spell checker for code
				"jsonlint", -- json linter
			},
		})

		--
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
		--

		local formatting = null_ls.builtins.formatting -- formatting sources
		local diagnostics = null_ls.builtins.diagnostics -- diagnostic sources
		local code_actions = null_ls.builtins.code_actions -- code action sources
		local hover = null_ls.builtins.hover -- hover sources
		local completion = null_ls.builtins.completion -- completion sources

		-- to setup format on save
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- register any number of sources simultaneously
		local sources = {
			--  to disable file types use
			--  "formatting.prettierd.with({disabled_filetypes: {}})" (see null-ls docs)
			formatting.prettier.with({
				extra_filetypes = {
					"javascript",
					"typescript",
					"css",
					"scss",
					"html",
					"json",
					"yaml",
					"markdown",
					"graphql",
					"md",
					"txt",
				},
			}), -- js/ts formatter
			formatting.stylua, -- lua formatter
			formatting.isort,
			formatting.black,
			formatting.shfmt,
			formatting.beautysh,
			completion.spell,
			diagnostics.pylint,
			diagnostics.eslint_d.with({ -- js/ts linter
				condition = function(utils)
					return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
				end,
			}),
		}

		-- configure null_ls
		null_ls.setup({
			-- add package.json as identifier for root (for typescript monorepos)
			root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
			-- setup formatters & linters
			sources = sources,
			-- configure format on save
			on_attach = function(current_client, bufnr)
				if current_client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								filter = function(client)
									--  only use null-ls for formatting instead of lsp server
									return client.name == "null-ls"
								end,
								bufnr = bufnr,
							})
						end,
					})
				end
			end,
		})
	end,
}
