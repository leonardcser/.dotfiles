return {
	"ej-shafran/compile-mode.nvim",
	-- tag = "v5.*",
	-- you can just use the latest version:
	branch = "latest",
	-- or the most up-to-date updates:
	-- branch = "nightly",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- if you want to enable coloring of ANSI escape codes in
		-- compilation output, add:
		-- { "m00qek/baleia.nvim", tag = "v1.3.0" },
	},
	config = function()
		---@type CompileModeOpts
		vim.g.compile_mode = {
			-- to add ANSI escape code support, add:
			-- baleia_setup = true,
		}

		local keymap = vim.keymap

		keymap.set("n", "<leader>cc", ":Compile<CR>", { desc = "Compile code" })
		keymap.set("n", "<leader>cr", ":Recompile<CR>", { desc = "Recompile code" })
		keymap.set("n", "<leader>ce", ":NextError<CR>", { desc = "Goto next error" })
	end,
}
