return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local diffview = require("diffview")

		diffview.setup({
			view = {
				default = {
					layout = "diff2_vertical",
				},
			},
			hooks = {
				view_opened = function(view)
					vim.g.diffview_is_open = true
					vim.g.diffview_tab_id = view.tabpage

					vim.keymap.set("c", "q<CR>", "tabclose<CR>")
				end,
				view_closed = function()
					vim.g.diffview_is_open = false
					vim.g.diffview_tab_id = nil
					vim.keymap.set("c", "q<CR>", "q<CR>")
				end,
			},
		})

		-- Initialize state tracking for diffview session
		vim.g.diffview_is_open = false
		vim.g.diffview_tab_id = nil

		-- Clean up state if diffview tab is closed manually
		vim.api.nvim_create_autocmd("TabClosed", {
			callback = function()
				if vim.g.diffview_tab_id and not vim.api.nvim_tabpage_is_valid(vim.g.diffview_tab_id) then
					vim.g.diffview_is_open = false
					vim.g.diffview_tab_id = nil
				end
			end,
		})

		vim.keymap.set("n", "<leader>gd", function()
			-- Close fugitive if it's open
			if
				vim.g.fugitive_is_open
				and vim.g.fugitive_tab_id
				and vim.api.nvim_tabpage_is_valid(vim.g.fugitive_tab_id)
			then
				vim.api.nvim_set_current_tabpage(vim.g.fugitive_tab_id)
				vim.cmd("tabclose")
				vim.g.fugitive_is_open = false
				vim.g.fugitive_tab_id = nil
			end

			if
				vim.g.diffview_is_open
				and vim.g.diffview_tab_id
				and vim.api.nvim_tabpage_is_valid(vim.g.diffview_tab_id)
			then
				-- Move to the existing diffview tab and refresh
				vim.api.nvim_set_current_tabpage(vim.g.diffview_tab_id)
				vim.cmd("DiffviewRefresh")
			else
				-- Open new diffview
				vim.cmd("DiffviewOpen")
			end
		end, { desc = "Open diffview" })

		vim.keymap.set("n", "<leader>gh", function()
			vim.cmd("DiffviewFileHistory")
		end, { desc = "Toggle file history" })

		vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory %<CR>", { desc = "Open current file history" })
	end,
}
