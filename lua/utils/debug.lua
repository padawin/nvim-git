local M = {}

function M.dump_table(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. M.dump_table(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function M.print(file_name, value)
	local file = io.open(file_name, "a")
	if file ~= nil then
		io.output(file)
		io.write(value)
		io.close(file)
	end
end

return M
