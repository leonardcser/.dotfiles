return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_save = true,
			auto_restore = true,
			args_allow_files_auto_save = true,
			purge_after_minutes = 10080,
			suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/", "/" },
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
	end,
}
