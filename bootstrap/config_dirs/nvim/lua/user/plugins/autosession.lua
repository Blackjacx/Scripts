return {
	"rmagatti/auto-session",
	lazy = false,
	init = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
	dependencies = {
		-- "nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
	},
	keys = {
		-- Will use Telescope if installed or a vim.ui.select picker otherwise
		{ "<leader>ww", "<cmd>SessionSearch<CR>", desc = "Session search" },
		{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Session save" },
		{ "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
	},
	opts = {
		bypass_save_filetypes = { "alpha", "dashboard" }, -- or whatever dashboard you use
		suppressed_dirs = { "/", "~/", "~/Downloads" },
		-- log_level = 'debug',
		auto_restore = true, -- Enables/disables auto restoring session on start
		session_lens = {
			load_on_setup = false, -- prevent loading telescope with autosession, which is required on startup
		},
	},
}
