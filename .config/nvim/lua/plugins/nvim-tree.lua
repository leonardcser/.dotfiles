return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-tree-crossclip",
	},
	cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle", "NvimTreeRefresh" },
	init = function()
		-- Open nvim-tree when opening a directory
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function(data)
				if vim.fn.isdirectory(data.file) == 1 then
					require("nvim-tree.api").tree.open()
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>ee",
			function()
				local api = require("nvim-tree.api")
				api.tree.toggle({ find_file = false, winid = vim.api.nvim_get_current_win(), focus = true })
			end,
			desc = "Toggle file explorer",
		},
		{
			"<leader>ef",
			function()
				local api = require("nvim-tree.api")
				api.tree.toggle({ find_file = true, winid = vim.api.nvim_get_current_win(), focus = true })
			end,
			desc = "Toggle file explorer on current file",
		},
		{ "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
		{
			"<leader>es",
			function()
				local api = require("nvim-tree.api")
				local core = require("nvim-tree.core")
				local sort_modes = { "name", "modification_time" }
				-- Store index on the function itself
				vim.g._nvim_tree_sort_index = ((vim.g._nvim_tree_sort_index or 0) % #sort_modes) + 1
				local sort_mode = sort_modes[vim.g._nvim_tree_sort_index]
				if core and core.get_explorer() then
					local explorer = core.get_explorer()
					if explorer and explorer.opts and explorer.opts.sort then
						explorer.opts.sort.sorter = sort_mode
					end
				end
				api.tree.reload()
			end,
			desc = "Cycle sort mode",
		},
	},
	config = function()
		local nvimtree = require("nvim-tree")

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
			},
			live_filter = {
				prefix = "[FILTER]: ",
				always_show_folders = false,
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
					quit_on_open = true,
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)
				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end
				vim.keymap.set("n", "<CR>", api.node.open.replace_tree_buffer, opts("Open: In Place"))

				local plugin = require("nvim-tree-crossclip")
				vim.keymap.set("n", "c", plugin.copy_toggle, opts("Copy"))
				vim.keymap.set("n", "x", plugin.cut_toggle, opts("Cut"))
				vim.keymap.set("n", "p", plugin.paste, opts("Paste"))
			end,
		})

		local api = require("nvim-tree.api")
		api.events.subscribe(api.events.Event.FileCreated, function(file)
			vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
		end)
	end,
}
