-- General-purpose motion plugin. It allows you to reach any target in a very
-- fast, uniform way, and minimizes the required focus level while executing a jump.
-- https://github.com/ggandor/leap.nvim
return {
	"ggandor/leap.nvim",
	-- keys = {
	--   { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
	--   { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
	--   { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	-- },
	config = function(_, _)
		local leap = require("leap")
		-- for k, v in pairs(opts) do
		--   leap.opts[k] = v
		-- end
		leap.add_default_mappings(true)
		-- vim.keymap.del({ "x", "o" }, "x")
		-- vim.keymap.del({ "x", "o" }, "X")
	end,
}
