local M = {}

function M.restore()
	-- Read Themery's selection without loading its picker or the other themes.
	local path = vim.fn.stdpath("data") .. "/themery/state.json"
	local ok, state = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
	end)
	local name = ok and type(state) == "table" and state.colorscheme or "nord"
	if not pcall(vim.cmd.colorscheme, name) then
		vim.cmd.colorscheme("nord")
	end
end

return M
