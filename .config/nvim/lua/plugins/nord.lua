local function apply_nord_highlights()
	vim.cmd([[highlight @tag gui=bold guifg=#9BBAD8]])
	vim.cmd([[highlight @tag.delimiter gui=bold guifg=#7A8CAA]])
	vim.cmd([[highlight @tag.attribute guifg=#81A1C1]])
	vim.cmd([[highlight @attribute guifg=#FFD75E]])
	vim.cmd([[highlight Comment guifg=#5E6A80 gui=NONE]])
	vim.cmd([[highlight @comment guifg=#5E6A80 gui=NONE]])
	vim.cmd([[highlight Identifier guifg=#ECEFF4]])
	vim.cmd([[highlight @variable guifg=#ECEFF4]])
	vim.cmd([[highlight @variable.member guifg=#ECEFF4]])
	vim.cmd([[highlight @property guifg=#ECEFF4]])
	vim.cmd([[highlight @field guifg=#ECEFF4]])
	vim.cmd([[highlight Constant guifg=#D08FE6]])
	vim.cmd([[highlight @constant guifg=#D08FE6]])
	vim.cmd([[highlight @constant.builtin guifg=#FFD75E]])
	vim.cmd([[highlight @constant.macro guifg=#FFD75E]])
	vim.cmd([[highlight Function guifg=#88C0D0]])
	vim.cmd([[highlight @function guifg=#88C0D0]])
	vim.cmd([[highlight @function.method guifg=#88C0D0]])
	vim.cmd([[highlight Type guifg=#8AA4D0]])
	vim.cmd([[highlight @type guifg=#8AA4D0]])
	vim.cmd([[highlight @type.builtin guifg=#A3D6D4]])
	vim.cmd([[highlight String guifg=#B8D89A]])
	vim.cmd([[highlight @string guifg=#B8D89A]])
	vim.cmd([[highlight Keyword guifg=#81A1C1]])
	vim.cmd([[highlight @keyword guifg=#81A1C1]])
	vim.cmd([[highlight CursorLine guibg=#141920]])
	vim.cmd([[highlight ColorColumn guibg=#141920]])
	vim.cmd([[highlight TreesitterContext guibg=#141920]])
	vim.cmd([[highlight IblIndent guifg=#2A303C]])
end

return {
	"shaunsingh/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.nord_disable_background = true
		vim.g.nord_italic = false

		local group = vim.api.nvim_create_augroup("nord_custom_highlights", { clear = true })
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = group,
			pattern = "nord",
			callback = apply_nord_highlights,
		})

		if vim.g.colors_name == "nord" then
			apply_nord_highlights()
		end
	end,
}
