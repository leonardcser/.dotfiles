return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build",
	config = function()
		require("cursortab").setup({
			log_level = "debug",
			provider = {
				type = "sweep",
				model = "sweep-next-edit-1.5b-mlx",
				-- url = "http://llm.box.lan",
				url = "http://localhost:8000",
				max_tokens = 128,
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
