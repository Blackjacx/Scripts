vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")

		map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

		local wk = require("which-key")
		wk.add({
			{ "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
			{ "<leader>lA", vim.lsp.buf.range_code_action, desc = "Range Code Actions" },
			{ "<leader>ls", vim.lsp.buf.signature_help, desc = "Display Signature Information" },
			{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename all references" },
			{ "<leader>lf", vim.lsp.buf.format, desc = "Format" },
			{
				"<leader>lc",
				require("core.utils").copyFilePathAndLineNumber,
				desc = "Copy File Path and Line Number",
			},
			{ "<leader>Wa", vim.lsp.buf.add_workspace_folder, desc = "Workspace Add Folder" },
			{ "<leader>Wr", vim.lsp.buf.remove_workspace_folder, desc = "Workspace Remove Folder" },
			{
				"<leader>Wl",
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				desc = "Workspace List Folders",
			},
		})

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client:supports_method(client, "textDocument/completion", event.bufbuf) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})
