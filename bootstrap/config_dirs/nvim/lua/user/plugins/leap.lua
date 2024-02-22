-- Leap is a general-purpose motion plugin for Neovim, building and improving primarily on vim-sneak,
-- with the ultimate goal of establishing a new standard interface for moving around in the visible
-- area in Vim-like modal editors. It allows you to reach any target in a very fast, uniform way,
-- and minimizes the required focus level while executing a jump.

return {
	"ggandor/leap.nvim",
	-- keys = {
	--   { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
	--   { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
	--   { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	-- },
	config = function(_, opts)
		local leap = require("leap")
		-- for k, v in pairs(opts) do
		--   leap.opts[k] = v
		-- end
		leap.add_default_mappings(true)
		-- vim.keymap.del({ "x", "o" }, "x")
		-- vim.keymap.del({ "x", "o" }, "X")
	end,
}
