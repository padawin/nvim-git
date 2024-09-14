local git = require("lua.git.internal.git")
local diff = require("lua.git.internal.diff")
local hunk = require("lua.git.internal.hunk")
local table_utils = require("lua.git.internal.table")
local M = {}

local close_diff_window = function(buf, file_path)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	if #lines ~= 1 then -- A buffer has at least one line, even if empty
		local error = git.stage_patch(file_path)
		if error ~= nil then
			return error
		end
	end
	vim.api.nvim_buf_delete(buf, {})
	os.remove(file_path)
end

local fix_patch_headers = function(buf)
	-- Get buffer content
	local buf_content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
	-- Parse hunk
	local files = diff.parse(buf_content)
	-- Adjust headers
	for _, file in pairs(files) do
		for _, h in pairs(file.hunks) do
			hunk.adjust_header(h)
		end
	end
	-- Rewrite buffer content (maybe if changed)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, diff.get_files_content(files))
end

function M.create_buffer_with_diff(hunk_content)
	local file_path = os.tmpname()
	vim.api.nvim_command('new')
	local buf = vim.api.nvim_get_current_buf()
	vim.cmd('edit ' .. file_path)
	vim.api.nvim_buf_set_option(buf, 'filetype', 'diff')
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, hunk_content)
	vim.cmd('write')
	vim.api.nvim_create_autocmd(
		'WinClosed',
		{
			callback = function()
				fix_patch_headers(buf)
				vim.cmd('write')
				local error = close_diff_window(buf, file_path)
				if error ~= nil then
					print(error)
					-- WinClosed will close the window regardless of the error.
					-- So let's reopen it, so the user can adjust their patch
					vim.api.nvim_command('split')
					return error
				end
				vim.cmd('silent edit')
			end,
			buffer = buf
		}
	)
end

return M
