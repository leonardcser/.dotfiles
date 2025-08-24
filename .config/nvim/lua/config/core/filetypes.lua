-- Filetype settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "Brewfile",
	callback = function()
		vim.bo.filetype = "ruby"
	end,
})
