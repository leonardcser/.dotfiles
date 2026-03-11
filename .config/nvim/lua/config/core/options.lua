-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs (prettier default)
opt.softtabstop = 2
opt.shiftwidth = 4 --  2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.colorcolumn = "80"

-- search
opt.hlsearch = true
opt.incsearch = true

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line
opt.guicursor = ""

-- mouse
-- opt.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example
vim.opt.mouse = "" -- Disable mouse for learning

-- history & session
vim.opt.undofile = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- trigger `autoread` when files changes on disk
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- notification after file change
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.api.nvim_echo({ { "File changed on disk. Buffer reloaded.", "WarningMsg" } }, true, {})
	end,
})

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.scrolloff = 8
opt.sidescrolloff = 10
opt.showmode = false
opt.laststatus = 2

-- lsp progress
_G.lsp_progress = { client = "", msg = "", pct = 0, active = false }
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			local val = args.data.params.value
			lsp_progress.client = client.name
			lsp_progress.msg = val.message or ""
			lsp_progress.pct = val.percentage or 0
			lsp_progress.active = val.kind ~= "end"
			vim.cmd("redrawstatus")
		end
	end,
})

-- statusline
local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local function statusline()
	local modes = {
		["n"] = { "NORMAL", "StlNormal" },
		["i"] = { "INSERT", "StlInsert" },
		["v"] = { "VISUAL", "StlVisual" },
		["V"] = { "V-LINE", "StlVisual" },
		["\22"] = { "V-BLOCK", "StlVisual" },
		["c"] = { "COMMAND", "StlCommand" },
		["R"] = { "REPLACE", "StlReplace" },
		["t"] = { "TERMINAL", "StlNormal" },
	}

	local mode = vim.api.nvim_get_mode().mode
	local m = modes[mode] or { mode:upper(), "StlNormal" }

	local diag = ""
	local counts = vim.diagnostic.count(0)
	local errors = counts[vim.diagnostic.severity.ERROR] or 0
	local warnings = counts[vim.diagnostic.severity.WARN] or 0
	if errors > 0 then
		diag = diag .. "  %#StlError#󰅚 " .. errors
	end
	if warnings > 0 then
		diag = diag .. " %#StlWarn#" .. warnings
	end
	if diag ~= "" then
		diag = diag .. "%#StatusLine#"
	end

	local right = {}

	if lsp_progress.active then
		local idx = math.floor(vim.fn.reltimestr(vim.fn.reltime()) * 10) % #spinner_frames + 1
		local text = lsp_progress.client
		if lsp_progress.msg ~= "" then
			text = text .. ": " .. lsp_progress.msg
		end
		if lsp_progress.pct > 0 then
			text = text .. string.format(" (%d%%%%)", lsp_progress.pct)
		end
		if #text > 30 then
			text = text:sub(1, 29) .. "…"
		end
		table.insert(right, "%#StlLsp#" .. spinner_frames[idx] .. " " .. text)
	end

	local ok, tracker = pcall(require, "wpm-tracker")
	if ok and tracker.get_current_wpm() > 0 then
		table.insert(right, "%#StlWpm#" .. tracker.get_wpm_display())
	end

	local lok, lazy_status = pcall(require, "lazy.status")
	if lok and lazy_status.has_updates() then
		table.insert(right, "%#StlLazy#" .. lazy_status.updates())
	end

	table.insert(right, "%#StatusLine#%{&filetype}")
	table.insert(right, "%{&encoding}")
	table.insert(right, "%l:%c")
	table.insert(right, "%p%%")

	return table.concat({
		"%#", m[2], "# ", m[1], " %#StatusLine#",
		diag,
		"  %f %m%r",
		"%=",
		table.concat(right, "  "),
		" ",
	})
end

_G.Statusline = statusline
opt.statusline = "%!v:lua.Statusline()"

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("statusline-colors", { clear = true }),
	callback = function()
		local bg = "#112638"
		vim.api.nvim_set_hl(0, "StatusLine", { fg = "#c3ccdc", bg = bg })
		vim.api.nvim_set_hl(0, "StlNormal", { fg = bg, bg = "#65D1FF", bold = true })
		vim.api.nvim_set_hl(0, "StlInsert", { fg = bg, bg = "#3EFFDC", bold = true })
		vim.api.nvim_set_hl(0, "StlVisual", { fg = bg, bg = "#FF61EF", bold = true })
		vim.api.nvim_set_hl(0, "StlCommand", { fg = bg, bg = "#FFDA7B", bold = true })
		vim.api.nvim_set_hl(0, "StlReplace", { fg = bg, bg = "#FF4A4A", bold = true })
		vim.api.nvim_set_hl(0, "StlLsp", { fg = "#FFDA7B", bg = bg })
		vim.api.nvim_set_hl(0, "StlWpm", { fg = "#3EFFDC", bg = bg })
		vim.api.nvim_set_hl(0, "StlLazy", { fg = "#ff9e64", bg = bg })
		vim.api.nvim_set_hl(0, "StlError", { fg = "#BF616A", bg = bg })
		vim.api.nvim_set_hl(0, "StlWarn", { fg = "#EBCB8B", bg = bg })
	end,
})
opt.ffs = "unix"

-- tabbar
vim.opt.showtabline = 0

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard (OSC 52 for remote clipboard sync over SSH/mosh)
if os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION") then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
opt.updatetime = 200

-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- diff colors and settings
vim.opt.fillchars:append({ diff = "╱" }) -- diagonal lines for deleted lines
vim.opt.diffopt:append({ "vertical", "iwhite", "algorithm:histogram" })

-- Custom diff colors
vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Set custom diff colors",
	group = vim.api.nvim_create_augroup("diff-colors", { clear = true }),
	callback = function()
		-- Diff colors with foreground colors for fillchars
		vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1e2a18" })
		vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#773333", bg = "#2a1414" })
		vim.api.nvim_set_hl(0, "DiffChange", { bg = "#151e11" })
		vim.api.nvim_set_hl(0, "DiffText", { bg = "#293a22" })
	end,
})

-- Apply colors immediately if colorscheme is already loaded
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Apply diff colors on startup",
	callback = function()
		vim.cmd("doautocmd ColorScheme")
	end,
})
