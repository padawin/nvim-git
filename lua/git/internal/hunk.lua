local table_utils = require("git.internal.table")
local M = {}

local build_header = function(hunk)
	local header = "@@ -" .. hunk.old_pos
	if hunk.old_len ~= 1 then
		header = header .. "," .. hunk.old_len
	end
	header = header .. " +" .. hunk.new_pos
	if hunk.new_len ~= 1 then
		header = header .. "," .. hunk.new_len
	end
	header = header .. " @@"
	return header
end

function M.new(header)
	local hunk = {}
	-- header is like:
	-- @@ -93,10 +93,6
	local old_pos, old_len = string.match(header, '@@ .(%d+),(%d+) ')
	if old_pos == nil then
		old_pos = string.match(header, '@@ .(%d+) ')
		old_len = 1
	end
	local new_pos, new_len = string.match(header, ' .(%d+),(%d+) @@')
	if new_pos == nil then
		new_pos = string.match(header, ' .(%d+) @@')
		new_len = 1
	end
	hunk.old_pos = tonumber(old_pos)
	hunk.old_len = tonumber(old_len)
	hunk.new_pos = tonumber(new_pos)
	hunk.new_len = tonumber(new_len)
	hunk.content = {}
	return hunk
end

function M.add_line(hunk, line)
	table.insert(hunk.content, line)
	return hunk
end

function M.adjust_header(hunk)
	local count_old_lines = 0
	local count_new_lines = 0
	for _, line in pairs(hunk.content) do
		local control = string.sub(line, 1, 1)
		if control == ' ' then
			count_old_lines = count_old_lines + 1
			count_new_lines = count_new_lines + 1
		elseif control == '+' then
			count_new_lines = count_new_lines + 1
		elseif control == '-' then
			count_old_lines = count_old_lines + 1
		end
	end
	hunk.old_len = count_old_lines
	hunk.new_len = count_new_lines
end

function M.get_content(hunk)
	return table_utils.merge(
		{build_header(hunk)},
		hunk.content
	)
end

return M
