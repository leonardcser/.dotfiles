return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", ":tab Git<CR>", { desc = "Open git status" })
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Push git changes" })
		vim.keymap.set("n", "<leader>gP", ":Git pull --rebase<CR>", { desc = "Pull git changes" })
		vim.keymap.set("n", "<leader>ga", ":Git add -u<CR>", { desc = "Add git changes" })
	end,
}
