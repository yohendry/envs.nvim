local _close_window = function(win)
	if vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
end

return function(text, options, window_list)
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
	local title = "    envs  "

	if options.window.style ~= nil then
		style = options.window.style
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
	table.insert(window_list, popup)
	local group = vim.api.nvim_create_augroup("envs_floating_node", { clear = true })

	local close_window = function()
		for _, window in ipairs(window_list) do
			_close_window(window)
		end
		window_list = {}
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
