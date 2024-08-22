return {
	"rcarriga/nvim-notify",
	event = { "VeryLazy" },
	config = function()
		-- import plugin safely
		local plugin = require("notify")

		-- enable
		plugin.setup()
	end,
}
