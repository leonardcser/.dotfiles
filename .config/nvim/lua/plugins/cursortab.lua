return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build -o cursortab .",
	config = function()
		require("cursortab").setup({
			log_level = "debug",
			debug_immediate_shutdown = true,
			provider = "sweep",
			provider_model = "sweep-next-edit-1.5b",
			provider_url = "http://localhost:8000",
			provider_max_tokens = 256,
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":CursortabToggle<CR>", { desc = "Toggle Cursortab" })
	end,
}
