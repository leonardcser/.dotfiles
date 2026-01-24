return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build -o cursortab .",
	config = function()
		require("cursortab").setup({
			log_level = "debug",
			provider = {
				type = "sweep",
				url = "http://llm.box.lan",
				model = "sweep-next-edit-1.5b",
			},
			debug = {
				immediate_shutdown = true,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":CursortabToggle<CR>", { desc = "Toggle Cursortab" })
	end,
}
