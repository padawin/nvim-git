local file = require("lua.git.internal.file")
local hunk = require("lua.git.internal.hunk")
-- Creates an object for the module.
local M = {}

function M.parse(diff)
	local curr_file = nil
	local currentHunk = nil
	local state = ""
	local files = {}
	for line in diff:gmatch("[^\r\n]+") do
		if line:sub(1, 4) == "diff" then
			if curr_file ~= nil then
				file.add_hunk(curr_file, currentHunk)
				table.insert(files, curr_file)
			end
			curr_file = file.new(line)
			state = "in_header"
		elseif line:sub(1, 1) == '@' then
			if curr_file == nil then
				print("ParseError: Hunk found without a file")
				return files
			end
			state = "in_hunks"
			if currentHunk ~= nil then
				file.add_hunk(curr_file, currentHunk)
			end
			currentHunk = hunk.new(curr_file.header, line)
		else
			if state == "in_header" then
				file.complete_header(curr_file, line)
			else
				hunk.add_line(currentHunk, line)
			end
		end
	end
	-- Last file
	if curr_file ~= nil then
		file.add_hunk(curr_file, currentHunk)
		table.insert(files, curr_file)
	end
	return files
end

return M
