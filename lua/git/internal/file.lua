local table_utils = require("lua.git.internal.table")
local hunk = require("lua.git.internal.hunk")

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
		if line_number < h.new_pos + h.new_len then
			return h
		end
	end
end

function M.get_content(file)
	local content = file.header
	for _, h in pairs(file.hunks) do
		content = table_utils.merge(content, hunk.get_content(h))
	end
	return content
end

return M
