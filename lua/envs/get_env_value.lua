local utils = require("envs.util")
local get_envs_in_path = require("envs.get_envs_in_path")
local get_env_display_value = function(key, value)
	return key .. "=" .. value
end

-- ZSH_THEME ZSH

return function(callback, not_found_prefix)
	local cword = vim.fn.expand("<cword>") -- get current word
	local result = not_found_prefix .. "¯\\_(ツ)_/¯ " .. cword .. " not found" -- initialize with word not gound

	local root = vim.fn.getcwd() -- get current working directory
	local root_parts = utils.split(root, utils.path_separator) -- devide root path into each folder

	local current_path = utils.path_separator -- start current path with '/' for unix systems
	if utils.is_windows then
		current_path = "C:" .. utils.path_separator -- replace current path with 'C:\' in case of windows
	end

	local envs = {}

	for _, folder in ipairs(root_parts) do -- iterate over the folders in search of the env files
		current_path = utils.path_join(current_path, folder)
		local current_envs = get_envs_in_path(current_path)
		envs = vim.tbl_extend("force", envs, current_envs)
	end
	local value_local = envs[cword]

	if value_local ~= nil then
		result = get_env_display_value(cword, value_local)
	else -- if no env file contains the value, we search in the system
		local ok, value = pcall(vim.loop.os_getenv, cword)
		if ok and value ~= nil then
			result = get_env_display_value(cword, value)
		end -- Checks if current word is an environment variable
	end

	if type(callback) == "function" then
		callback({ result })
	end

	return result
end
