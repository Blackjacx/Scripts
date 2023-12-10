-- import plugin safely
local status, plugin = pcall(require, "which-key")
if not status then
	return
end

vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- configure plugin
plugin.setup()
