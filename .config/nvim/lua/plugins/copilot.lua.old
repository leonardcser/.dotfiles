return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "VeryLazy",
	opts = function()
		return {
			workspace_folders = { vim.fn.getcwd() },
			filetypes = { markdown = true, help = true },

			nes = { enabled = false },
			panel = { enabled = false },
			suggestion = {
				enabled = false,
				auto_trigger = false,
				hide_during_completion = true,
			},
		}
	end,
}
