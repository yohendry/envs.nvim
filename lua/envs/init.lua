local M = {}

M.get_env_value = require("envs.get_env_value")
M.show_popup = require("envs.show-popup")

M.setup = function(opts)
	vim.api.nvim_create_user_command("ShowEnv", function()
		local callback = function() end

		if opts.print == true then
			callback = vim.print
		end
		local result = M.get_env_value(callback, opts.not_found)

		if opts.popup then
			M.show_popup(" " .. result .. " ", opts)
		end
	end, {})
end
return M
