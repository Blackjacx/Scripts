-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- get lualine nightfly theme
local lualine_gruvbox = require("lualine.themes.gruvbox-material")

-- configure lualine with modified theme
lualine.setup({
	options = {
		icon_enabled = true,
		theme = lualine_gruvbox,
	},
})
