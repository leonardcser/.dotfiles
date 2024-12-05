return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
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
			end,
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		local api = require("nvim-tree.api")

		local function toggle()
			api.tree.toggle({ find_file = false, winid = vim.api.nvim_get_current_win(), focus = true })
		end
		local function toggle_current_file()
			api.tree.toggle({ find_file = true, winid = vim.api.nvim_get_current_win(), focus = true })
		end

		keymap.set("n", "<leader>ee", toggle, { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>ef", toggle_current_file, { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
