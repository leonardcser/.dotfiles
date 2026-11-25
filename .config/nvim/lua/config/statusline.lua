local M = {}

local modes = {
	n = { "NORMAL", "StlNormal" },
	i = { "INSERT", "StlInsert" },
	v = { "VISUAL", "StlVisual" },
	V = { "V-LINE", "StlVisual" },
	["\22"] = { "V-BLOCK", "StlVisual" },
	c = { "COMMAND", "StlCommand" },
	R = { "REPLACE", "StlReplace" },
	t = { "TERMINAL", "StlNormal" },
}
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local progress = { client = "", msg = "", pct = 0, active = false }

function M.render()
	local mode = vim.api.nvim_get_mode().mode
	local m = modes[mode] or { mode:upper(), "StlNormal" }
	local parts = { "%#" .. m[2] .. "# " .. m[1] .. " %#StatusLine#" }
	if vim.g.dev_mode then
		local counts = vim.diagnostic.count(0)
		local errors = counts[vim.diagnostic.severity.ERROR] or 0
		local warnings = counts[vim.diagnostic.severity.WARN] or 0
		if errors > 0 then
			table.insert(parts, "%#StlError#󰅚 " .. errors)
		end
		if warnings > 0 then
			table.insert(parts, "%#StlWarn#󰀪 " .. warnings)
		end
	end
	table.insert(parts, "%#StatusLine#%f %m%r%=")
	if progress.active then
		local text = progress.client
		if progress.msg ~= "" then
			text = text .. ": " .. progress.msg
		end
		if progress.pct > 0 then
			text = text .. string.format(" (%d%%)", progress.pct)
		end
		text = vim.fn.strcharpart(text, 0, 30):gsub("%%", "%%%%")
		table.insert(parts, "%#StlLsp#" .. spinner[math.floor(vim.uv.now() / 100) % #spinner + 1] .. " " .. text)
	end
	local tracker = package.loaded["wpm-tracker"]
	if tracker and tracker.get_current_wpm() > 0 then
		table.insert(parts, "%#StlWpm#" .. tracker.get_wpm_display())
	end
	local updates = require("lazy.status")
	if updates.has_updates() then
		table.insert(parts, "%#StlLazy#" .. updates.updates())
	end
	table.insert(parts, "%#StatusLine#%{&filetype}  %{&encoding}  %l:%c  %p%% ")
	return table.concat(parts, "  ")
end

--- Hide LSP progress, for example after all servers stop.
function M.clear_progress()
	progress.active = false
	vim.cmd.redrawstatus()
end

vim.o.laststatus = 2
vim.o.showmode = false
vim.o.statusline = "%!v:lua.require'config.statusline'.render()"

vim.api.nvim_create_autocmd("LspProgress", {
	group = vim.api.nvim_create_augroup("statusline-lsp-progress", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		local value = args.data.params.value
		progress.client = client.name
		progress.msg = value.message or ""
		progress.pct = value.percentage or 0
		progress.active = value.kind ~= "end"
		vim.cmd.redrawstatus()
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("statusline-colors", { clear = true }),
	callback = function()
		local bg = "#112638"
		vim.api.nvim_set_hl(0, "StatusLine", { fg = "#c3ccdc", bg = bg })
		for name, color in pairs({
			Normal = "#65D1FF",
			Insert = "#3EFFDC",
			Visual = "#FF61EF",
			Command = "#FFDA7B",
			Replace = "#FF4A4A",
		}) do
			vim.api.nvim_set_hl(0, "Stl" .. name, { fg = bg, bg = color, bold = true })
		end
		for name, color in pairs({
			Lsp = "#FFDA7B",
			Wpm = "#3EFFDC",
			Lazy = "#ff9e64",
			Error = "#BF616A",
			Warn = "#EBCB8B",
		}) do
			vim.api.nvim_set_hl(0, "Stl" .. name, { fg = color, bg = bg })
		end
	end,
})

return M
