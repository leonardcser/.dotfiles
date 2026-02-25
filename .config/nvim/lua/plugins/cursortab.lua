return {
	-- "leonardcser/cursortab.nvim",
	-- version = "*",  -- Use latest tagged version for more stability
	dir = vim.fn.stdpath("config") .. "/custom/cursortab.nvim",
	-- dir = "/Users/leo/.dotfiles/.config/nvim/custom/cursortab.nvim-feat-side-side",
	build = "cd server && go build",
	lazy = false,
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
				type = "sweep",
				url = "https://llm.box.home.arpa",
				model = "sweep-next-edit-1.5B-Q8_0",
				-- model = "Qwen2.5-Coder-1.5B-Q8_0",
				api_key_env = "BOX_API_KEY",
				-- api_key_env = "SWEEPAI_API_KEY",
				-- api_key_env = "MERCURY_API_KEY",
				max_tokens = 1024,
			},
			behavior = {
				max_visible_lines = 4,
				ignore_gitignored = false,
				-- enabled_modes = { "insert" }, -- Modes where completions are active
				-- idle_completion_delay = -1, -- Delay in ms after idle to trigger completion (-1 to disable)
				-- text_change_debounce = -1, -- Debounce in ms after text change to trigger completion (-1 to disable)
			},
			ui = {
				-- completions = {
				-- 	addition_style = "dimmed",
				-- },
			},
			-- blink = {
			-- 	enabled = true,
			-- 	ghost_text = true,
			-- },
			-- debug = {
			-- 	immediate_shutdown = true,
			-- },
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":CursortabToggle<CR>", { desc = "Toggle Cursortab" })
	end,
}
