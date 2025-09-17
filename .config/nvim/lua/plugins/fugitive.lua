return {
	"tpope/vim-fugitive",
	config = function()
		-- Initialize state tracking for fugitive session
		vim.g.fugitive_is_open = false
		vim.g.fugitive_tab_id = nil

		-- Clean up state if fugitive tab is closed manually
		vim.api.nvim_create_autocmd("TabClosed", {
			callback = function()
				if vim.g.fugitive_tab_id and not vim.api.nvim_tabpage_is_valid(vim.g.fugitive_tab_id) then
					vim.g.fugitive_is_open = false
					vim.g.fugitive_tab_id = nil
				end
			end,
		})

		vim.keymap.set("n", "<leader>gs", function()
			-- Check if we're in a Git repository
			local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
			if git_root == "" or vim.v.shell_error ~= 0 then
				vim.notify("Not in a Git repository", vim.log.levels.WARN)
				return
			end

			-- Close diffview if it's open
			if
				vim.g.diffview_is_open
				and vim.g.diffview_tab_id
				and vim.api.nvim_tabpage_is_valid(vim.g.diffview_tab_id)
			then
				vim.api.nvim_set_current_tabpage(vim.g.diffview_tab_id)
				vim.cmd("tabclose")
				vim.g.diffview_is_open = false
				vim.g.diffview_tab_id = nil
			end

			-- Open fugitive and track state
			vim.cmd("tab Git")

			-- Try to find modified files first, fallback to untracked files
			local success = pcall(function()
				vim.cmd("/^M ")
			end)

			if not success then
				-- Fallback to untracked files pattern
				local untracked_success = pcall(function()
					vim.cmd("/^? ")
				end)
				-- If neither pattern exists, don't move cursor (no error thrown)
			end

			vim.cmd(':let @/=""')

			-- Track the fugitive tab
			vim.g.fugitive_is_open = true
			vim.g.fugitive_tab_id = vim.api.nvim_get_current_tabpage()
		end, { desc = "Open git status" })
	end,
}
