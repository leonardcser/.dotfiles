return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/cursortab.nvim",
	build = "cd server && go build",
	config = function()
		require("cursortab").setup({
			log_level = "debug",
			keymaps = {
				-- accept = false, -- Let blink.cmp manage <Tab>
				-- partial_accept = false,
				-- trigger = "<S-Tab>",
			},
			provider = {
				-- url = "http://localhost:8000",
				url = "http://llm.box.home.arpa",
				type = "sweep",
				api_key_env = "CURSORTAB_AUTH_TOKEN",
				max_tokens = 512,
			},
			behavior = {
				max_visible_lines = 4,
				-- idle_completion_delay = -1, -- Delay in ms after idle to trigger completion (-1 to disable)
				-- text_change_debounce = -1, -- Debounce in ms after text change to trigger completion (-1 to disable)
			},
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
