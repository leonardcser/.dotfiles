return {
	"shaunsingh/nord.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		vim.g.nord_disable_background = true
		vim.g.nord_italic = false
		vim.cmd([[colorscheme nord]])
	end,
}
