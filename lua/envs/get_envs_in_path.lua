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
return get_envs_in_path
