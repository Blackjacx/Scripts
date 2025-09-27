return {
	"nvim-tree/nvim-web-devicons",
	config = function()
		local icons = require("nvim-web-devicons")

		icons.set_icon({
			gql = {
				icon = "",
				color = "#e535ab",
				cterm_color = "199",
				name = "GraphQL",
			},
		})
	end,
}
