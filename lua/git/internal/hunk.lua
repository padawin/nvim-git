local table_utils = require("lua.git.internal.table")
local M = {}

function M.new(file_header, header)
	if type(file_header) ~= "table" then error("file header in hunk must be a table") end
	local hunk = {}
	-- file_header is like:
	-- diff --git a/plugin/git.vim b/plugin/git.vim
	-- index 2ff4ba5..74e2df3 100644
	-- --- a/plugin/git.vim
	-- +++ b/plugin/git.vim

	-- header is like:
	-- @@ -93,10 +93,6
	hunk.file_header = file_header
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

function M.get_content(hunk)
	return table_utils.merge(
		hunk.file_header,
		table_utils.merge(
			{build_header(hunk)},
			hunk.content
		)
	)
end

return M
