return {
	"nvim-lua/plenary.nvim",
	keys = {
		{
			"<leader>bs",
			function()
				local scratch_file = vim.fn.stdpath("data") .. "/scratch.txt"
				vim.cmd("tabnew")
				vim.cmd("edit " .. vim.fn.fnameescape(scratch_file))
				local buf = vim.api.nvim_get_current_buf()
				vim.bo[buf].buflisted = false
				vim.wo.statusline = "%#Normal# SCRATCH "
			end,
			desc = "Scratch Buffer (tab)",
			mode = "n",
		},
		{
			"<leader>bS",
			function()
				local scratch_file = vim.fn.stdpath("data") .. "/scratch.txt"
				vim.cmd("vsplit")
				vim.cmd("edit " .. vim.fn.fnameescape(scratch_file))
				local buf = vim.api.nvim_get_current_buf()
				vim.bo[buf].buflisted = false
				vim.wo.statusline = "%#Normal# SCRATCH "
			end,
			desc = "Scratch Buffer (vsplit)",
			mode = "n",
		},
	},
}
