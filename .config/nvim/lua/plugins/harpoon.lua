return {
	"ThePrimeagen/harpoon",
	config = function()
		require("harpoon").setup()

		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<C-x>", mark.add_file, { desc = "Add file to Harpoon" })
		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon" })

		vim.keymap.set("n", "<C-p>", ui.nav_prev, { desc = "Harpoon prev file" })
		vim.keymap.set("n", "<C-n>", ui.nav_next, { desc = "Harpoon next file" })
		vim.keymap.set("n", "<CR>", vim.api.nvim_replace_termcodes("<CR>", true, false, true), { noremap = true })
	end,
}
