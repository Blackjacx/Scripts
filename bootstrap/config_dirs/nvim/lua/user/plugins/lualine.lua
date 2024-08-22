return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- event = "VeryLazy",
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		-- local mason = require("mason-registry") -- to configure lazy pending updates count
		local gruvbox_material_theme = require("lualine.themes.gruvbox-material") -- get lualine gruvbox-material theme

		local function lspClients()
			local msg = ""
			local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
		end

		-- check for mason package upgrades
		local function lualine_mason_updates()
			local registry = require("mason-registry")
			local installed_packages = registry.get_installed_package_names()
			local upgrades_available = false
			local packages_outdated = 0
			function myCallback(success, result_or_err)
				if success then
					upgrades_available = true
					packages_outdated = packages_outdated + 1
				end
			end

			for _, pkg in pairs(installed_packages) do
				local p = registry.get_package(pkg)
				if p then
					p:check_new_version(myCallback)
				end
			end

			if upgrades_available then
				return packages_outdated
			else
				return ""
			end
		end

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				-- theme = my_lualine_theme,
				theme = gruvbox_material_theme,
			},
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
						on_click = function()
							vim.cmd("Lazy")
						end,
					},
					{
						lualine_mason_updates,
						icon = "",
						color = { fg = "#ff9e64" },
						on_click = function()
							vim.cmd("Mason")
						end,
					},
					{ "filetype" },
					{
						lspClients,
						icon = "󰧁",
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "os.date('%H:%M:%S')" },
				},
			},
			extensions = {
				"mason",
				"fugitive",
				"fzf",
				"lazy",
				"mason",
				"man",
				"mundo",
				"neo-tree",
				"nvim-dap-ui",
				"overseer",
				"quickfix",
			},
		})
	end,
}
