return {
	dir = vim.fn.stdpath("config") .. "/custom/nvim-tree-crossclip.nvim",
	name = "nvim-tree-crossclip",
	lazy = true,
	dependencies = "nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree-crossclip").setup()
	end,
}
