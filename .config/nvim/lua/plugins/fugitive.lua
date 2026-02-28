return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
	keys = {
		{
			"<leader>gs",
			function()
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
					vim.cmd("/^[MDRA] ")
				end)

				if not success then
					-- Fallback to untracked files pattern
					pcall(function()
						vim.cmd("/^? ")
					end)
				end

				vim.cmd(':let @/=""')

				-- Track the fugitive tab
				vim.g.fugitive_is_open = true
				vim.g.fugitive_tab_id = vim.api.nvim_get_current_tabpage()
			end,
			desc = "Open git status",
		},
	},
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

		-- Show +N -M diff stats as virtual text in fugitive status buffer
		local ns = vim.api.nvim_create_namespace("fugitive_diffstat")
		local function get_fg(name)
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			return hl.fg
		end
		vim.api.nvim_set_hl(0, "FugitiveDiffAdd", { fg = get_fg("diffAdded") or get_fg("DiffAdd") or "#26a641" })
		vim.api.nvim_set_hl(0, "FugitiveDiffDel", { fg = get_fg("diffRemoved") or get_fg("DiffDelete") or "#f85149" })

		local function parse_numstat(output)
			local stats = {}
			for _, line in ipairs(vim.split(output, "\n", { trimempty = true })) do
				local add, del, file = line:match("^(%d+)%s+(%d+)%s+(.+)$")
				if file then
					stats[file] = { add = (stats[file] and stats[file].add or 0) + tonumber(add), del = (stats[file] and stats[file].del or 0) + tonumber(del) }
				end
			end
			return stats
		end

		local function make_stat_chunks(add, del)
			local chunks = {}
			if add > 0 then
				table.insert(chunks, { "+" .. add, "FugitiveDiffAdd" })
				table.insert(chunks, { " ", "" })
			end
			if del > 0 then
				table.insert(chunks, { "-" .. del, "FugitiveDiffDel" })
			end
			return chunks
		end

		local function total_stats(stats)
			local add, del = 0, 0
			for _, s in pairs(stats) do
				add = add + s.add
				del = del + s.del
			end
			return add, del
		end

		local function apply_annotations(buf, unstaged_stats, staged_stats)
			vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
			local all_stats = vim.deepcopy(unstaged_stats)
			for file, s in pairs(staged_stats) do
				all_stats[file] = { add = (all_stats[file] and all_stats[file].add or 0) + s.add, del = (all_stats[file] and all_stats[file].del or 0) + s.del }
			end
			local unstaged_add, unstaged_del = total_stats(unstaged_stats)
			local staged_add, staged_del = total_stats(staged_stats)
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			for i, line in ipairs(lines) do
				-- Totals on section headers (e.g. "Unstaged (3)", "Staged (2)")
				if line:match("^Unstaged") then
					local chunks = make_stat_chunks(unstaged_add, unstaged_del)
					if #chunks > 0 then
						vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { virt_text = chunks, virt_text_pos = "eol", hl_mode = "combine" })
					end
				elseif line:match("^Staged") then
					local chunks = make_stat_chunks(staged_add, staged_del)
					if #chunks > 0 then
						vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { virt_text = chunks, virt_text_pos = "eol", hl_mode = "combine" })
					end
				end
				-- Per-file stats
				local file = line:match("^[MDARCU?!]%s+(.+)$")
				if file and all_stats[file] then
					local chunks = make_stat_chunks(all_stats[file].add, all_stats[file].del)
					if #chunks > 0 then
						vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { virt_text = chunks, virt_text_pos = "eol", hl_mode = "combine" })
					end
				end
			end
		end

		local pending_timer = nil
		local function annotate_fugitive(buf)
			if pending_timer then
				pending_timer:stop()
			end
			pending_timer = vim.defer_fn(function()
				pending_timer = nil
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				local done = 0
				local unstaged_out, staged_out = "", ""
				local function on_complete()
					done = done + 1
					if done < 2 then
						return
					end
					vim.schedule(function()
						if not vim.api.nvim_buf_is_valid(buf) then
							return
						end
						apply_annotations(buf, parse_numstat(unstaged_out), parse_numstat(staged_out))
					end)
				end
				vim.system({ "git", "diff", "--numstat" }, { text = true }, function(obj)
					unstaged_out = obj.stdout or ""
					on_complete()
				end)
				vim.system({ "git", "diff", "--cached", "--numstat" }, { text = true }, function(obj)
					staged_out = obj.stdout or ""
					on_complete()
				end)
			end, 50)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "fugitive",
			callback = function(ev)
				annotate_fugitive(ev.buf)
				-- Re-annotate when buffer content changes (e.g. staging/unstaging)
				vim.api.nvim_create_autocmd("BufReadPost", {
					buffer = ev.buf,
					callback = function()
						annotate_fugitive(ev.buf)
					end,
				})
			end,
		})
	end,
}
