local M = {}

function M.new(header)
	local file = {}
	file.header = {header}
	file.hunks = {}
	return file
end

function M.complete_header(file, line)
	table.insert(file.header, line)
end

function M.add_hunk(file, hunk)
	table.insert(file.hunks, hunk)
	return file
end

function M.find_hunk_after_line(file, line_number)
	if file == nil then return nil end

	for _, h in pairs(file.hunks) do
		if line_number <= h.start_line or line_number < h.end_line then
			return h
		end
	end
end
return M
