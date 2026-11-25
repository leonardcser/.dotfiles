return {
	"artemave/workspace-diagnostics.nvim",
	event = "User Dev",
	config = function()
		require("workspace-diagnostics").setup()
	end,
}

