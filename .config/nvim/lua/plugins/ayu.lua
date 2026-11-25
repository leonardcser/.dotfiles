return {
	"Shatur/neovim-ayu",
	config = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "ayu-dark",
			callback = function()
				-- Use the terminal background everywhere except the status and tab lines.
				for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
					if hl.bg and not (name:match("^StatusLine") or name:match("^TabLine") or name:match("^Stl")) then
						hl.bg = nil
						vim.api.nvim_set_hl(0, name, hl)
					end
				end
			end,
		})
	end,
}
