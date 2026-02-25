return {
	dir = vim.fn.stdpath("config") .. "/custom/nvim-tree-crossclip.nvim",
	name = "nvim-tree-crossclip",
	lazy = true,
	config = function()
		require("nvim-tree-crossclip").setup()
	end,
}
