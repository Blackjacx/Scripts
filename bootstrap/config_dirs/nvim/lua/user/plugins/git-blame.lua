return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	config = function()
		-- import comment plugin safely
		local plugin = require("gitblame")

		-- Note how the `gitblame_` prefix is omitted in `setup`
		plugin.setup({
			enabled = true,
			message_template = "  <summary> • <date> • <author> • <sha>",
			date_format = "%r",
			message_when_not_committed = "  Oh please, commit this !",
			-- delay = 1000,
			use_blame_commit_file_urls = true,
		})
	end,
}
