-- import plugin safely
local setup, plugin = pcall(require, "nvim-surround")
if not setup then
	return
end

-- enable comment
plugin.setup({
	-- Configuration here, or leave empty to use defaults
})
