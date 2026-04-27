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
			"MeanderingProgrammer/treesitter-modules.nvim",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local languages = {
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
				"regex",
				"ruby",
				"swift",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			}

			-- Covers ensure_installed + highlight + indent + fold + incremental selection
			local ts = require("treesitter-modules")
			ts.setup({
				ensure_installed = languages,
				ignore_install = {},
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = { enable = true },
				fold = { enable = false },
				incremental_selection = {
					enable = false, -- NOTE: enabling this conflixts with <C-i> (go forward in jumplist)
					keymaps = {
						init_selection = "<TAB>",
						node_incremental = "<TAB>",
						node_decremental = "<S-TAB>",
						scope_incremental = false,
					},
				},
			})

			-- Fold settings (do not fold)
			-- vim.opt.foldmethod = "expr"
			-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

			-- autotag
			require("nvim-ts-autotag").setup()

			-- textobjects plugin now uses its own setup + keymaps
			require("nvim-treesitter-textobjects").setup({
				move = {
					set_jumps = false,
				},
				select = {
					lookahead = true,
				},
			})
		end,
	},
}
