return {
	"zaldih/themery.nvim",
	lazy = false,
	config = function()
		require("themery").setup({
			themes = {
				{
					name = "ayu-dark",
					colorscheme = "ayu-dark",
					after = [[
						for _, name in ipairs(vim.fn.getcompletion("", "highlight")) do
							if not (name:match("^StatusLine") or name:match("^TabLine") or name:match("^Lualine") or name:match("^MiniStatusline")) then
								local hl = vim.api.nvim_get_hl(0, { name = name })
								if hl.bg then
									vim.api.nvim_set_hl(0, name, { bg = nil })
								end
							end
						end
					]],
				},
				"ayu-light",
				"ayu-mirage",
				"gruvbox",
				"kanagawa",
				"kanagawa-dragon",
				"kanagawa-wave",
				"nord",
			},
		})
	end,
}
