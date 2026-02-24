return {
	dir = vim.fn.stdpath("config") .. "/custom/wpm-tracker.nvim",
	cmd = { "WPMStats", "WPMLog" },
	event = "InsertEnter",
	keys = {
		{ "<leader>wps", "<cmd>WPMStats<cr>", desc = "Show WPM statistics" },
		{ "<leader>wpl", "<cmd>WPMLog<cr>", desc = "Open WPM log file" },
	},
	config = function()
		require("wpm-tracker").setup({
			log_file = vim.fn.stdpath("data") .. "/wpm-tracker.csv",
			average_window = 500,
			min_session_length = 3000,
			update_interval = 1000,
			idle_timeout = 2000,
		})
	end,
}
