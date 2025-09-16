return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local diffview = require("diffview")

		diffview.setup()

		-- Smart toggle keymap for diffview
		vim.keymap.set("n", "<leader>gd", function()
			-- Check if we're in a diffview buffer
			if vim.bo.filetype == "DiffviewFiles" or vim.bo.filetype == "DiffviewFileHistory" then
				vim.cmd("DiffviewClose")
			else
				vim.cmd("DiffviewOpen")
			end
		end, { desc = "Toggle diffview" })

		-- Smart toggle keymap for file history
		vim.keymap.set("n", "<leader>gh", function()
			-- Check if we're in a diffview buffer
			if vim.bo.filetype == "DiffviewFiles" or vim.bo.filetype == "DiffviewFileHistory" then
				vim.cmd("tabclose")
			else
				vim.cmd("DiffviewFileHistory")
			end
		end, { desc = "Toggle file history" })

		-- Keymap for opening current file history
		vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory %<CR>", { desc = "Open current file history" })
	end,
}
