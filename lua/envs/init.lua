local M = {}

M.get_env_value = require("envs.get_env_value")
M.show_popup = require("envs.show-popup")
M.opts = require("envs.defaults")
M.active_window = nil
M.setup = function(opts)
	if opts ~= nil and vim.tbl_count(opts) > 0 then
		opts = vim.tbl_extend("force", M.opts, opts)
	else
		opts = M.opts
	end

	vim.api.nvim_create_user_command("ShowEnv", function()
		local callback = function() end

		if opts.print == true then
			callback = vim.print
		end

		local result = M.get_env_value(callback, opts.not_found_prefix)

		if opts.popup then
			M.show_popup(" " .. result .. " ", opts)
		end
	end, {})
end
return M
