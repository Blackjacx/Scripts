-- Tree-sitter is a parser generator tool and an incremental parsing library.
-- It can build a concrete syntax tree for a source file and efficiently update
-- the syntax tree as the source file is edited. Tree-sitter aims to be:
--
-- - **General** enough to parse any programming language
-- - **Fast** enough to parse on every keystroke in a text editor
-- - **Robust** enough to provide useful results even in the presence of syntax errors
-- - **Dependency-free** so that the runtime library (which is written in pure C) can be embedded in any application
--
-- ## Links
--
-- - [Documentation](https://tree-sitter.github.io)
-- - [Rust binding](lib/binding_rust/README.md)
-- - [WASM binding](lib/binding_web/README.md)
-- - [Command-line interface](cli/README.md)

return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "dotenv",
			-- 	-- command = set syntax = "bash" filetype = "dotenv"
			-- 	command = "set syntax=bash",
			-- 	-- autocmd FileType md set syntax=markdown filetype=markdown
			-- })

			-- local filetype_augroup = vim.api.nvim_create_augroup("FileType", { clear = true })
			-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			-- 	group = filetype_augroup,
			-- 	command = "set syntax=bash",
			-- 	-- callback = function()
			-- 	-- 	vim.cmd("set syntax=bash")
			-- 	-- end,
			-- })

			-- configure treesitter
			treesitter.setup({
				-- enable syntax highlighting
				highlight = { enable = true },
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = { enable = true },
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,
				-- ensure these language parsers are installed
				ensure_installed = {
					"bash",
					"css",
					"dockerfile",
					"gitignore",
					"graphql",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"query",
					"ruby",
					"swift",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<TAB>",
						node_incremental = "<TAB>",
						node_decremental = "<S-TAB>",
						scope_incremental = false,
					},
				},
			})

			-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
			require("ts_context_commentstring").setup({})
		end,
	},
}
