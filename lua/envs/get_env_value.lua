local file_exists = require("file-exist")
local lines_from = require("lines-from")
local split = require("split")

return function(callback)
	local cword = vim.fn.expand("<cword>")

	-- Checks if cword is an environment variable
	-- If cword is environment variable and value not nil, show in hover window value of environment variable
	-- Else show in hover window "Error! `cword` is not an environment variable!"
	local ok, value = pcall(vim.loop.os_getenv, cword)
	if ok and value ~= nil then
	else -- not a system env
		local root = vim.fn.getcwd()
		local envPath = root .. "/.env"
		local envLocalPath = envPath .. ".local"

		local envs = {}

		if file_exists(envPath) then
			local lines = lines_from(envPath)

			for _, line in ipairs(lines) do
				local response = split(line, "=")

				if response ~= false then
					local envName, envValue = unpack(response)

					envs[envName] = envValue
				end
			end
		end

		if file_exists(envLocalPath) then
			local lines = lines_from(envLocalPath)
			for _, line in ipairs(lines) do
				local responseLocal = split(line, "=")

				if responseLocal ~= false then
					local envName, envValue = unpack(responseLocal)

					envs[envName] = envValue
				end
			end
		end

		local value_local = envs[cword]

		local result = "¯\\_(ツ)_/¯ " .. cword .. " not found"

		if value_local ~= nil then
			result = cword .. "= " .. value_local
		end
		if type(callback) == "function" then
			callback({ result })
		end
		return result
	end
end
