-- https://www.josean.com/posts/neovim-linting-and-formatting
return {
	"stevearc/conform.nvim",
	enable = true,
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		-- Nearest directory wins; within one directory, .swiftformat beats .config/swiftformat
		local function find_swiftformat_config(start_dir)
			local candidates = { ".swiftformat", ".config/swiftformat" }

			local dirs = { start_dir }
			for parent in vim.fs.parents(start_dir) do
				table.insert(dirs, parent)
			end

			for _, dir in ipairs(dirs) do
				for _, name in ipairs(candidates) do
					local path = vim.fs.joinpath(dir, name)
					local stat = vim.uv.fs_stat(path)
					if stat and stat.type == "file" then
						return path
					end
				end
			end
		end

		conform.setup({
			formatters_by_ft = {
				bash = { "shfmt" },
				css = { "prettierd" },
				graphql = { "prettierd" },
				html = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				python = { "isort", "black" },
				ruby = { "rubocop" },
				sh = { "shfmt" },
				swift = { "swiftformat" },
				tex = { "latexindent" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				yaml = { "prettierd", "yamlfmt" },
				zsh = { "shfmt" },
			},
			formatters = {
				swiftformat = {
					prepend_args = function(_, ctx)
						local cfg = find_swiftformat_config(ctx.dirname)
						return cfg and { "--config", cfg } or {}
					end,
				},
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
				lsp_format = "fallback", -- `lsp_fallback` is the deprecated spelling
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
