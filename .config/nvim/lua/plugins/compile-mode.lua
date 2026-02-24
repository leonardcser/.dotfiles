return {
	"ej-shafran/compile-mode.nvim",
	branch = "latest",
	cmd = { "Compile", "Recompile", "NextError" },
	keys = {
		{ "<leader>cc", ":Compile<CR>", desc = "Compile code" },
		{ "<leader>cr", ":Recompile<CR>", desc = "Recompile code" },
		{ "<leader>ce", ":NextError<CR>", desc = "Goto next error" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		---@type CompileModeOpts
		vim.g.compile_mode = {}
	end,
}
