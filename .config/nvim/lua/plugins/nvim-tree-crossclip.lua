return {
	dir = vim.fn.stdpath("config") .. "/custom/nvim-tree-crossclip.nvim",
	name = "nvim-tree-crossclip",
	dependencies = "nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree-crossclip").setup()
	end,
}
