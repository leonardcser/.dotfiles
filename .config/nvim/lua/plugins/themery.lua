return {
	"zaldih/themery.nvim",
	cmd = "Themery",
	config = function()
		require("themery").setup({
			themes = {
				"ayu-dark",
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
