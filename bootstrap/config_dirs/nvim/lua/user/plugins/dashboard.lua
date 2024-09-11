return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	opts = {
		shuffle_letter = true,
		hide = {
			statusline = true, -- hide statusline default is true
			tabline = true, -- hide the tabline
			winbar = true, -- hide winbar
		},
		config = {
			week_header = {
				enable = true, --boolean use a week header
			},
			footer = {}, -- footer
			shortcut = {
				{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
				{
					icon = " ",
					icon_hl = "@variable",
					desc = "Files",
					group = "Label",
					action = "Telescope find_files",
					key = "f",
				},
				{
					desc = " Apps",
					group = "DiagnosticHint",
					action = "Telescope app",
					key = "a",
				},
				{
					desc = " dotfiles",
					group = "Number",
					action = "Telescope dotfiles",
					key = "d",
				},
			},
		},
	},
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
