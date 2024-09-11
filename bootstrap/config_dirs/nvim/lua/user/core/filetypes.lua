vim.filetype.add({
	extension = {
		conf = "conf",
		env = "sh",
		envrc = "sh",
	},
	filename = {
		[".env"] = "sh",
		[".envrc"] = "sh",
		["swiftformat"] = "sh",
		["Cartfile"] = "sh",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
		["%.envrc%.[%w_.-]+"] = "sh",
	},
})
