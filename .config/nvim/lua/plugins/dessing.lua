return {
	"stevearc/dressing.nvim",
	init = function()
		local input, select = vim.ui.input, vim.ui.select
		for _, name in ipairs({ "input", "select" }) do
			vim.ui[name] = function(...)
				vim.ui.input, vim.ui.select = input, select
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui[name](...)
			end
		end
	end,
}
