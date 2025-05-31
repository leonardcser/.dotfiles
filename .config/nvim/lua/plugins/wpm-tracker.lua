return {
  "leonardcser/wpm-tracker.nvim",
  config = function()
    require("wpm-tracker").setup({
      -- Log file location (CSV format)
      log_file = vim.fn.stdpath("data") .. "/wpm-tracker.csv",
      -- Rolling average window size
      average_window = 10,
      -- Minimum session length to record (seconds)
      min_session_length = 5,
      -- Update interval for lualine (milliseconds)
      update_interval = 1000,
    })
    
    -- Add keymaps for WPM commands
    vim.keymap.set("n", "<leader>ws", "<cmd>WPMStats<cr>", { desc = "Show WPM statistics" })
    vim.keymap.set("n", "<leader>wl", "<cmd>WPMLog<cr>", { desc = "Open WPM log file" })
  end,
} 