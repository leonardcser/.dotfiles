return {
	"shaunsingh/nord.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		vim.g.nord_disable_background = true
		vim.g.nord_italic = false
		vim.cmd([[colorscheme nord]])

		-- HTML
		vim.cmd([[highlight @tag gui=bold guifg=#81A1C1]])
		vim.cmd([[highlight @tag.delimiter gui=bold guifg=#616E88]])
		vim.cmd([[highlight @tag.attribute guifg=#9876AA]])

		-- Goto labels & function decorators
		vim.cmd([[highlight @attribute guifg=#EBCB8B]])

		-- Highligting
		vim.cmd([[highlight CursorLine guibg=#191D23]])
		vim.cmd([[highlight ColorColumn guibg=#191D23]])
		vim.cmd([[highlight TreesitterContext guibg=#191D23]])
		vim.cmd([[highlight IblIndent guifg=#191D23]])
	end,
}
