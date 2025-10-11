-- Filetype settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "Brewfile",
	callback = function()
		vim.bo.filetype = "ruby"
	end,
})

-- Enable spell checking for markdown and typst files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "typst" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
