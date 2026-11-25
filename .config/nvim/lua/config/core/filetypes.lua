-- Large or minified files get the "bigfile" filetype. No parser, language
-- server, syntax file or ftplugin exists for it, so they open as plain text.
local max_bytes = 2 * 1024 * 1024
local max_avg_line = 1000
local min_minified_bytes = 256 * 1024

vim.api.nvim_create_autocmd("BufReadPre", {
	desc = "Skip undo file validation, which hashes the whole buffer, for large files",
	callback = function(ev)
		if vim.fn.getfsize(ev.match) >= max_bytes then
			vim.b[ev.buf].bigfile = true
			vim.bo[ev.buf].undofile = false
		end
	end,
})

vim.filetype.add({
	filename = { Brewfile = "ruby" },
	pattern = {
		[".*"] = {
			function(_, buf)
				if not buf or not vim.api.nvim_buf_is_loaded(buf) then
					return
				end
				if vim.b[buf].bigfile then
					return "bigfile"
				end
				local lines = vim.api.nvim_buf_line_count(buf)
				local bytes = vim.api.nvim_buf_get_offset(buf, lines)
				if bytes >= min_minified_bytes and bytes / lines > max_avg_line then
					return "bigfile"
				end
			end,
			{ priority = math.huge },
		},
	},
})

-- Enable spell checking for markdown and typst files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "typst" },
	callback = function()
		local langs = { "en" }
		if #vim.api.nvim_get_runtime_file("spell/fr.*.spl", false) > 0 then
			table.insert(langs, "fr")
		end
		vim.opt_local.spelllang = langs
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
