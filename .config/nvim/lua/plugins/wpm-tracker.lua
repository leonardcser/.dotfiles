return {
	-- "leonardcser/wpm-tracker.nvim",
	dir = "~/dev/lua/wpm-tracker.nvim",
	config = function()
		require("wpm-tracker").setup({
			-- Log file location (CSV format)
			log_file = vim.fn.stdpath("data") .. "/wpm-tracker.csv",
			-- Rolling average window size
			average_window = 500,
			-- Minimum session length to record (milliseconds)
			min_session_length = 3000,
			-- Update interval for lualine (milliseconds)
			update_interval = 1000,
			-- Stop tracking after inactivity (milliseconds)
			idle_timeout = 2000,
		})

		-- Add keymaps for WPM commands
		vim.keymap.set("n", "<leader>wps", "<cmd>WPMStats<cr>", { desc = "Show WPM statistics" })
		vim.keymap.set("n", "<leader>wpl", "<cmd>WPMLog<cr>", { desc = "Open WPM log file" })
	end,
}
