local M = {}

M.get_env_value = require("get_env_value")
M.show_popup = require("show-popup")

M.setup = function(opts)
	vim.api.nvim_create_user_command("ShowEnv", function()
		local callback = function() end

		if opts.print == true then
			callback = vim.print
		end
		local result = M.print_env(callback)

		if opts.popup then
			M.hover_popup(" " .. result .. " ", opts)
		end
	end, {})

	vim.keymap.set(
		"n",
		opts.open_mappings,
		[[<cmd>ShowEnv<cr>]],
		{ buffer = 0, desc = "Show ENV variable under cursor" }
	)
end
return M
