return {
	"artemave/workspace-diagnostics.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("workspace-diagnostics").setup()
	end,
}

