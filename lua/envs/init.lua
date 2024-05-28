local M = {}

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
M.lines_from = function(file)
	if not M.file_exists(file) then
		return {}
	end
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

M.split = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	local parts = {}

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(parts, str)
	end

	if vim.tbl_count(parts) > 1 then
		for index, part in ipairs(parts) do
			if index <= 2 then
				table.insert(t, part)
			else
				t[2] = t[2] .. "=" .. part
			end
		end
		return t
	else
		return false
	end
end

M.print_env = function(callback)
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

		if M.file_exists(envPath) then
			local lines = M.lines_from(envPath)

			for _, line in ipairs(lines) do
				local response = M.split(line, "=")

				if response ~= false then
					local envName, envValue = unpack(response)

					envs[envName] = envValue
				end
			end
		end

		if M.file_exists(envLocalPath) then
			local lines = M.lines_from(envLocalPath)
			for _, line in ipairs(lines) do
				local responseLocal = M.split(line, "=")

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

M.hover_popup = function(text, options)
	-- reduce signcolumn/foldcolumn from window width
	local function effective_win_width()
		local win_width = vim.fn.winwidth(0)

		-- return zero if the window cannot be found
		local win_id = vim.fn.win_getid()

		if win_id == 0 then
			return win_width
		end

		-- if the window does not exist the result is an empty list
		local win_info = vim.fn.getwininfo(win_id)

		-- check if result table is empty
		if next(win_info) == nil then
			return win_width
		end

		return win_width - win_info[1].textoff
	end

	local text_width = vim.fn.strdisplaywidth(vim.fn.substitute(text, "[^[:print:]]*$", "", "g"))
	local win_width = effective_win_width()

	if win_width < text_width then
		return
	end

	local style = "minimal"
	local border = "single"
	local title = "    print env  "

	if options.window.style ~= nil then
		style = options.window .. style
	end
	if options.window.border ~= nil then
		border = options.window.border
	end

	if options.window.title ~= nil then
		title = options.window.title
	end

	local popup = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
		relative = "cursor",
		row = 0,
		bufpos = { 0, 0 },
		width = math.min(text_width, vim.o.columns - 2),
		height = 1,
		noautocmd = true,
		style = style,
		border = border,
		title = title,
	})
	local group = vim.api.nvim_create_augroup("nvim_tree_floating_node", { clear = true })

	local close_window = function()
		M.close_window(popup)
	end
	vim.api.nvim_win_call(popup, function()
		vim.api.nvim_buf_set_lines(0, 0, -1, true, { text })

		vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved" }, {
			group = group,
			pattern = { "*" },
			callback = close_window,
		})

		local exit_keys = { "<Esc>", "q" }

		if options.close_mappings ~= nil and vim.tbl_count(options.close_mappings) > 0 then
			exit_keys = options.close_mappings
		end

		for _, key in ipairs(exit_keys) do
			vim.keymap.set("n", key, close_window)
		end

		vim.cmd("setlocal nowrap noswapfile nobuflisted buftype=nofile bufhidden=hide filetype=sh")
	end)
end

M.close_window = function(win)
	if vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
end
return M
