return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", ':tab Git<CR>/^M\\s<CR>:let @/=""<CR>', { desc = "Open git status" })
	end,
}
