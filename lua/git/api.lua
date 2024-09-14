local diff = require("lua.git.internal.diff")
local file = require("lua.git.internal.file")
local git = require("lua.git.internal.git")
local hunk = require("lua.git.internal.hunk")
local editor = require("lua.git.internal.vim")
local table_utils = require("lua.git.internal.table")

local M = {}

function M.run_next_hunk_diff()
	if not git.is_git_dir() then return end

	local curr_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
	local file_diff = git.get_file_diff(vim.fn.expand('%'))
	local files = diff.parse(file_diff)
	local h = file.find_hunk_after_line(files[1], curr_line)
	if h == nil then
		return
	end
	editor.create_buffer_with_diff(table_utils.merge(files[1].header, hunk.get_content(h)))
end

return M
