return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open git status" })
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Push git changes" })
	end,
}
