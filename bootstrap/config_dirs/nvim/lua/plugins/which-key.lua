-- Create key bindings that stick.
-- WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		spec = {
			-- { "<leader>f", group = "file" }, -- group
			-- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
			-- { "<leader>fb", function() print("hello") end, desc = "Foobar" },
			-- { "<leader>fn", desc = "New File" },
			-- { "<leader>f1", hidden = true }, -- hide this keymap
			-- { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings

			-- Group labels for the <leader> menu. The mappings themselves live in
			-- core/keymaps.lua, core/autocmds.lua (LSP, on LspAttach) and in the
			-- `keys` table of each plugin spec -- these entries only name the prefixes.
			{ "<leader>e", group = "explorer" }, -- <leader>e also toggles nvim-tree
			{ "<leader>f", group = "find (telescope)" },
			{ "<leader>g", group = "git" },
			{ "<leader>h", group = "git hunks" },
			{ "<leader>l", group = "lsp" },
			{ "<leader>m", group = "format" },
			{ "<leader>n", group = "swap w/ next + nohl" }, -- nh clears highlights, n{a,m,:} swap
			{ "<leader>p", group = "swap w/ previous" },
			{ "<leader>r", group = "replace + restart lsp" }, -- rw replaces word, rs restarts lsp
			{ "<leader>s", group = "splits" },
			{ "<leader>t", group = "tabs" },
			{ "<leader>w", group = "sessions" },
			{ "<leader>W", group = "workspace folders" },
			{ "<leader>x", group = "trouble" },

			{
				"<leader>b",
				group = "buffers",
				expand = function()
					return require("which-key.extras").expand.buf()
				end,
			},
			-- {
			--   -- Nested mappings are allowed and can be added in any order
			--   -- Most attributes can be inherited or overridden on any level
			--   -- There's no limit to the depth of nesting
			--   mode = { "n", "v" }, -- NORMAL and VISUAL mode
			--   { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
			--   { "<leader>w", "<cmd>w<cr>", desc = "Write" },
			-- }
			{

				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
