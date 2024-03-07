local git = require("lua.git.internal.git")
local M = {}

local close_diff_window = function(buf, file_path)
	local error = git.stage_patch(file_path)
	if error ~= nil then
		return error
	end
	vim.api.nvim_buf_delete(buf, {})
	os.remove(file_path)
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
				local error = close_diff_window(buf, file_path)
				if error ~= nil then
					print(error)
					-- WinClosed will close the window regardless of the error.
					-- So let's reopen it, so the user can adjust their patch
					vim.api.nvim_command('split')
					return error
				end
				vim.cmd('edit')
			end,
			buffer = buf
		}
	)
end

return M
