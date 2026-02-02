return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build",
	config = function()
		require("cursortab").setup({
			log_level = "debug",
			-- keymaps = {
			-- 	accept = false, -- Let blink.cmp manage <Tab>
			-- },
			provider = {
				-- url = "http://localhost:8000",
				url = "http://llm.box.lan",
				type = "sweep",
				api_key_env = "CURSORTAB_AUTH_TOKEN",
				max_tokens = 512,
			},
			-- behavior = {
			-- 	max_visible_lines = 2,
			-- },
			-- blink = {
			-- 	enabled = true,
			-- 	ghost_text = true,
			-- },
			debug = {
				immediate_shutdown = true,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":CursortabToggle<CR>", { desc = "Toggle Cursortab" })
	end,
}
