return {
	"Julian/lean.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	init = function()
		---@type lean.Config
		vim.g.lean_config = { mappings = true }
		require("config.dev").load_on_filetype("lean.nvim", "lean")
	end,
}
