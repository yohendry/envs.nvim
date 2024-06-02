local file_exists = require("envs.file-exist")
local read_lines = require("envs.read-lines")
local split = require("envs.split")
local utils = require("envs.util")
local get_envs_in_path = function(path)
	local envs = {}

	local files = { ".env", ".env.local" }
	for _, file in ipairs(files) do
		local filePath = utils.path_join(path, file)
		if file_exists(filePath) then
			local lines = read_lines(filePath)

			for _, line in ipairs(lines) do
				local response = split(line, "=")

				if response ~= false then
					local envName, envValue = unpack(response)

					envs[envName] = envValue
				end
			end
		end
	end
	return envs
end

local get_env_display_value = function(key, value)
	return key .. "=" .. value
end
return function(callback)
	local cword = vim.fn.expand("<cword>")
	local result = "¯\\_(ツ)_/¯ " .. cword .. " not found"
	local root = vim.fn.getcwd()

	local root_parts = utils.split(root, utils.path_separator)
	-- TODO: needs to check for windows start path, maybe from opts
	local current_path = utils.path_separator
	if utils.is_windows then
		current_path = "C:" .. utils.path_separator
	end
	local envs = {}
	for _, folder in ipairs(root_parts) do -- iterate over the folders in search of the env files
		current_path = utils.path_join(current_path, folder)
		vim.tbl_extend("force", envs, get_envs_in_path(current_path))
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
