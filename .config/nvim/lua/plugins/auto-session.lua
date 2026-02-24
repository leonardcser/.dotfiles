return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>wr", "<cmd>AutoSession restore<CR>", desc = "Restore session for cwd" },
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session for auto session root dir" },
	},
	opts = {
		auto_save = true,
		auto_restore = false,
		args_allow_files_auto_save = true,
		purge_after_minutes = 10080,
		suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/", "/" },
		session_lens = {
			load_on_setup = false,
		},
	},
}
