return {
	"rmagatti/auto-session",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
	},
	opts = {
		-- auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',

		-- More detailled error messages
		silent_restore = false,
	},
	config = true,
}
