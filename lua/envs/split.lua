return function(inputstr, sep)
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
