-- Filetype settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "Brewfile",
	callback = function()
		vim.bo.filetype = "ruby"
	end,
})

local function spelllang_available(lang)
	return #vim.fn.globpath(vim.o.runtimepath, "spell/" .. lang .. ".*.spl", false, true) > 0
end

local prose_spelllangs = { "en" }
if spelllang_available("fr") then
	table.insert(prose_spelllangs, "fr")
end

-- Enable spell checking for markdown and typst files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "typst" },
	callback = function()
		vim.opt_local.spelllang = prose_spelllangs
		vim.opt_local.spell = true
	end,
})

-- Enable soft wrap for prose-oriented filetypes and commit buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "typst", "tex", "text", "asciidoc", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})
