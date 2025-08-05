vim.filetype.add({
	extension = {
		conf = "sh", -- "conf", -- conf does not yield the correct syntax in tmux.conf
		env = "sh",
		envrc = "sh",
		tex = "tex",
	},
	filename = {
		[".env"] = "sh",
		[".envrc"] = "sh",
		["swiftformat"] = "sh",
		["Cartfile"] = "sh",
		["Cartfile.resolved"] = "sh",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
		["%.envrc%.[%w_.-]+"] = "sh",
	},
})
