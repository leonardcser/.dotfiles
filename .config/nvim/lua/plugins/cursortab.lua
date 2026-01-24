return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build -o cursortab .",
	config = function()
		require("cursortab").setup({
			debug_immediate_shutdown = true,
			provider = "sweep",
			provider_model = "sweep-next-edit-1.5b",
			provider_url = "http://llm.box.lan",

			provider_temperature = 0.0,

			max_context_tokens = 512,
			log_level = "debug",
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":CursortabToggle<CR>", { desc = "Toggle Cursortab" })
	end,
}
