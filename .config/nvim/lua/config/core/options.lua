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
vim.api.nvim_create_autocmd("FocusGained", {
	command = "checktime",
})
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function(ev)
		if vim.fn.mode() ~= "c" and vim.bo[ev.buf].buftype == "" then
			vim.cmd.checktime(ev.buf)
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

opt.ffs = "unix"

-- tabbar
vim.opt.showtabline = 0

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard (OSC 52 for local and remote terminal clipboard sync)
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
