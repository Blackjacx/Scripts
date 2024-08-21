vim.filetype.add({
	extension = {
		conf = "conf",
		env = "dotenv",
		envrc = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
		[".envrc"] = "dotenv",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
		["%.envrc%.[%w_.-]+"] = "dotenv",
	},
})
