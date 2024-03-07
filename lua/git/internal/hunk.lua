local M = {}

function M.new(file_header, header)
	local hunk = {}
	-- file_header is like:
	-- diff --git a/plugin/git.vim b/plugin/git.vim
	-- index 2ff4ba5..74e2df3 100644
	-- --- a/plugin/git.vim
	-- +++ b/plugin/git.vim

	-- header is like:
	-- @@ -93,10 +93,6
	hunk.file_header = file_header
	hunk.start_line = tonumber(string.match(header, '@@ .%d+,%d+ .(%d+),.*'))
	hunk.end_line = hunk.start_line + tonumber(string.match(header, '@@ .%d+,%d+ .%d+,(%d+).*'))
	hunk.content = {header}
	return hunk
end

function M.add_line(hunk, line)
	table.insert(hunk.content, line)
	return hunk
end

return M
