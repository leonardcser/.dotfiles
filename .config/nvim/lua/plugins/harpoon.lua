return {
	"ThePrimeagen/harpoon",
	keys = {
		{
			"<C-x>",
			function()
				require("harpoon.mark").add_file()
			end,
			desc = "Add file to Harpoon",
		},
		{
			"<C-e>",
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			desc = "Toggle Harpoon",
		},
		{
			"<C-p>",
			function()
				require("harpoon.ui").nav_prev()
			end,
			desc = "Harpoon prev file",
		},
		{
			"<C-n>",
			function()
				require("harpoon.ui").nav_next()
			end,
			desc = "Harpoon next file",
		},
	},
	config = function()
		require("harpoon").setup()
		vim.keymap.set("n", "<CR>", vim.api.nvim_replace_termcodes("<CR>", true, false, true), { noremap = true })
	end,
}
