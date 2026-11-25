-- Keep built-in highlighting without running language editing helpers.
vim.cmd("filetype plugin indent off")
vim.api.nvim_create_autocmd("FileType", {
	desc = "Highlight viewer buffers using installed Tree-sitter parsers",
	callback = function(ev)
		if vim.g.dev_mode or vim.bo[ev.buf].buftype ~= "" then
			return
		end
		local lang = vim.treesitter.language.get_lang(ev.match)
		if lang and vim.treesitter.language.add(lang) then
			local ok, query = pcall(vim.treesitter.query.get, lang, "highlights")
			if ok and query then
				vim.treesitter.start(ev.buf, lang)
			end
		end
	end,
})
