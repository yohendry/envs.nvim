return {
	popup = true, -- display a popup window relative to the cursor
	print = false, -- prnts the env value to `messages`
	window = {
		title = "   envs ", -- popup window title
		border = "double", -- popup border style
		style = "minimal", -- popup window style
	},
	not_found_prefix = " ",
	close_mappings = { "q", "<Esc>" }, -- key bindigs to close the popup
}
