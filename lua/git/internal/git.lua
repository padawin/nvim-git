local M = {}

local execute_command = function(command)
	local tmpfile = os.tmpname()
	local exit = os.execute(command .. ' > ' .. tmpfile .. ' 2> ' .. tmpfile .. '.err')

	local stdout_file = io.open(tmpfile)
	local stdout = stdout_file:read("*all")

	local stderr_file = io.open(tmpfile .. '.err')
	local stderr = stderr_file:read("*all")

	stdout_file:close()
	stderr_file:close()

	os.remove(tmpfile)
	os.remove(tmpfile .. '.err')

	return exit, stdout, stderr
end

function M.is_git_dir()
	local command = "git rev-parse --is-inside-work-tree"
	local success = execute_command(command)
	return success
end

function M.get_diff(file_path)
	if file_path == nil then file_path = "" end
	local command = "git diff " .. file_path
	local success, output = execute_command(command)
	if not success then
		print("Error: could not execute command: " .. command)
		return ""
	end
	return output
end

function M.stage_patch(file_path)
	local _, _, error = execute_command("git apply --cached " .. file_path)
	if error == "" then
		error = nil
	end
	return error
end

function M.get_staged_diff()
	local command = "git diff --cached"
	local success, output = execute_command(command)
	if not success then
		print("Error: could not execute command: " .. command)
		return ""
	end
	return output
end

function M.commit(message_file)
	local command = "git commit -F " .. message_file .. " 2>&1"
	local success, output, error = execute_command(command)
	if not success then
		print("Error while committing: " .. error)
		return ""
	else
		print(output)
	end
end

return M
