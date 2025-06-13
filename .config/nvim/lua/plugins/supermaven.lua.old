return {
	dir = "/Users/leo/dev/lua/supermaven-nvim/",
	config = function()
		require("supermaven-nvim").setup({
			color = {
				suggestion_color = "#81A1C1",
				cterm = 244,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":SupermavenToggle<CR>", { desc = "Toggle LLM Completions" })
	end,
}
