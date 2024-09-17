local file = require("git.internal.file")
local hunk = require("git.internal.hunk")
local table_utils = require("git.internal.table")
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
			currentHunk = nil
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
			currentHunk = hunk.new(line)
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

function M.get_files_content(files)
	local content = {}
	for _, f in pairs(files) do
		content = table_utils.merge(content, file.get_content(f))
	end
	return content
end

return M
