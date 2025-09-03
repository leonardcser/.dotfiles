return {
	-- "leonardcser/cursortab.nvim",
	dir = "~/dev/lua/cursortab.nvim",
	build = "cd server && go build -o cursortab .",
	config = function()
		require("cursortab").setup({
			debug_immediate_shutdown = true,
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":CursortabToggle<CR>", { desc = "Toggle Cursortab" })
	end,
}
