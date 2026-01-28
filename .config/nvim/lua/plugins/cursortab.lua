return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build",
	config = function()
		require("cursortab").setup({
			log_level = "debug",
			provider = {
				type = "sweep",
				-- type = "fim",
				url = "http://llm.box.lan",
				-- url = "http://localhost:8000",
				max_tokens = 1024,
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
