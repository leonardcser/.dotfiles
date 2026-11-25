local function output(argv)
	local cwd = vim.fn.FugitiveWorkTree()
	if cwd == "" or vim.fn.executable(argv[1]) == 0 then return nil end
	local result = vim.system(argv, { cwd = cwd, text = true }):wait()
	if result.code == 0 then return vim.trim(result.stdout) end
end

local function remote_url()
	local url = output({ "git", "remote", "get-url", "origin" })
	if not url then
		vim.notify("No origin remote for this repository", vim.log.levels.WARN)
		return nil
	end
	return (url:gsub("^git@github.com:", "https://github.com/"):gsub("%.git$", ""))
end

return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
	keys = {
		{ "<leader>gi", "<cmd>Git init<cr>", desc = "Initialize Git repository" },
		{ "<leader>gl", "<cmd>Git log<cr>", desc = "Show Git log" },
		{ "<leader>ga", "<cmd>Git add -u<cr>", desc = "Stage tracked changes" },
		{ "<leader>gp", "<cmd>Git push origin<cr>", desc = "Push to origin" },
		{ "<leader>gP", "<cmd>Git pull --rebase --prune<cr>", desc = "Pull with rebase" },
		{ "<leader>gf", "<cmd>Git push --force-with-lease<cr>", desc = "Push with lease" },
		{ "<leader>gr", function()
			local count = tonumber(output({ "git", "rev-list", "--count", "HEAD" }))
			if count then vim.cmd(count <= 6 and "Git rebase -i --root" or "Git rebase -i HEAD~6") end
		end, desc = "Interactive rebase" },
		{ "<leader>gu", function()
			local url = remote_url()
			if url then vim.fn.setreg("+", url); vim.notify("Copied remote URL") end
		end, desc = "Copy remote URL" },
		{ "<leader>go", function()
			local url = remote_url()
			if not url then return end
			local branch = output({ "git", "branch", "--show-current" })
			if branch and branch ~= "" and branch ~= "main" and branch ~= "master" then
				url = output({ "gh", "pr", "view", "--json", "url", "-q", ".url" }) or (url .. "/tree/" .. branch)
			end
			vim.ui.open(url)
		end, desc = "Open Git repository" },
		{
			"<leader>gs",
			function()
				-- Check if we're in a Git repository
				if vim.fn.FugitiveGitDir() == "" then
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

		local function parse_commit_numstat(output)
			local stats = {}
			local current = nil
			for _, line in ipairs(vim.split(output, "\n", { trimempty = true })) do
				local sha = line:match("^COMMIT (%x+)$")
				if sha then
					current = sha
					stats[current] = { add = 0, del = 0 }
				elseif current then
					local add, del = line:match("^(%d+)%s+(%d+)%s+")
					if add then
						stats[current].add = stats[current].add + tonumber(add)
						stats[current].del = stats[current].del + tonumber(del)
					end
				end
			end
			return stats
		end

		local function lookup_commit(commit_stats, short_sha)
			if commit_stats[short_sha] then
				return commit_stats[short_sha]
			end
			for full, stat in pairs(commit_stats) do
				if full:sub(1, #short_sha) == short_sha then
					return stat
				end
			end
			return nil
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

		local function apply_annotations(buf, unstaged_stats, staged_stats, commit_stats, head_stats)
			vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

			local function set_marks(line_idx, add, del)
				local chunks = make_stat_chunks(add, del)
				if #chunks > 0 then
					vim.api.nvim_buf_set_extmark(buf, ns, line_idx, 0, { virt_text = chunks, virt_text_pos = "eol", hl_mode = "combine" })
				end
			end

			-- Pre-compute totals for commit-list sections (Unpushed / Unpulled)
			local section_totals = {}
			local section_header = nil
			for i, line in ipairs(lines) do
				if line:match("^Unpushed") or line:match("^Unpulled") then
					section_header = i
					section_totals[i] = { add = 0, del = 0 }
				elseif section_header then
					local sha = line:match("^(%x%x%x%x%x%x%x+)%s")
					if sha then
						local stat = lookup_commit(commit_stats, sha)
						if stat then
							section_totals[section_header].add = section_totals[section_header].add + stat.add
							section_totals[section_header].del = section_totals[section_header].del + stat.del
						end
					elseif line:match("^%S") then
						section_header = nil
					end
				end
			end

			local current_section = nil
			for i, line in ipairs(lines) do
				local idx = i - 1
				if line:match("^Unstaged") then
					current_section = "unstaged"
					local a, d = total_stats(unstaged_stats)
					set_marks(idx, a, d)
				elseif line:match("^Staged") then
					current_section = "staged"
					local a, d = total_stats(staged_stats)
					set_marks(idx, a, d)
				elseif line:match("^Unpushed") or line:match("^Unpulled") then
					current_section = "commits"
					local total = section_totals[i]
					if total then
						set_marks(idx, total.add, total.del)
					end
				elseif line:match("^Head:") then
					current_section = nil
					if head_stats then
						local a, d = total_stats(head_stats)
						set_marks(idx, a, d)
					end
				elseif line:match("^Unmerged") or line:match("^Untracked") or line:match("^Push:") then
					current_section = nil
				end

				if current_section == "unstaged" or current_section == "staged" then
					local file = line:match("^[MDARCU?!]%s+(.+)$")
					if file then
						local section_stats = current_section == "staged" and staged_stats or unstaged_stats
						if section_stats[file] then
							set_marks(idx, section_stats[file].add, section_stats[file].del)
						end
					end
				elseif current_section == "commits" then
					local sha = line:match("^(%x%x%x%x%x%x%x+)%s")
					if sha then
						local stat = lookup_commit(commit_stats, sha)
						if stat then
							set_marks(idx, stat.add, stat.del)
						end
					end
				end
			end
		end

		local pending_timer = nil
		local current_gen = 0
		local function annotate_fugitive(buf)
			if pending_timer then
				pending_timer:stop()
			end
			pending_timer = vim.defer_fn(function()
				pending_timer = nil
				current_gen = current_gen + 1
				local mygen = current_gen
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				local shas = {}
				local seen = {}
				local in_commits = false
				for _, line in ipairs(lines) do
					if line:match("^Unpushed") or line:match("^Unpulled") then
						in_commits = true
					elseif line:match("^%S") and not line:match("^%x%x%x%x%x%x%x+%s") then
						in_commits = false
					end
					if in_commits then
						local sha = line:match("^(%x%x%x%x%x%x%x+)%s")
						if sha and not seen[sha] then
							seen[sha] = true
							table.insert(shas, sha)
						end
					end
				end

				local root = vim.fn.FugitiveWorkTree(buf)
				if root == "" then return end
				local git_opts = { cwd = root, text = true }
				local total_jobs = 3 + ((#shas > 0) and 1 or 0)
				local done = 0
				local unstaged_out, staged_out, commit_out, head_out = "", "", "", ""
				local function on_complete()
					done = done + 1
					if done < total_jobs or mygen ~= current_gen then
						return
					end
					vim.schedule(function()
						if not vim.api.nvim_buf_is_valid(buf) or mygen ~= current_gen then
							return
						end
						apply_annotations(
							buf,
							parse_numstat(unstaged_out),
							parse_numstat(staged_out),
							parse_commit_numstat(commit_out),
							parse_numstat(head_out)
						)
					end)
				end
				vim.system({ "git", "diff", "--numstat" }, git_opts, function(obj)
					unstaged_out = obj.stdout or ""
					on_complete()
				end)
				vim.system({ "git", "diff", "--cached", "--numstat" }, git_opts, function(obj)
					staged_out = obj.stdout or ""
					on_complete()
				end)
				vim.system({ "git", "diff", "--numstat", "origin/HEAD...HEAD" }, git_opts, function(obj)
					if obj.code == 0 then
						head_out = obj.stdout or ""
					end
					on_complete()
				end)
				if #shas > 0 then
					local cmd = { "git", "log", "--no-walk", "--numstat", "--format=COMMIT %H" }
					for _, sha in ipairs(shas) do
						table.insert(cmd, sha)
					end
					vim.system(cmd, git_opts, function(obj)
						commit_out = obj.stdout or ""
						on_complete()
					end)
				end
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
