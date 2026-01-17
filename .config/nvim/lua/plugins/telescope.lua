return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				-- path_display = { "smart" },
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/*",
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		-- Smart git files finder - shows message if not in git repo
		keymap.set("n", "<leader>fg", function()
			local builtin = require("telescope.builtin")
			-- Check if current directory is a git repository
			local git_dir = vim.fn.finddir(".git", ".;")
			if git_dir ~= "" then
				builtin.git_files()
			else
				-- Show message and don't open telescope
				vim.notify("Not in a git repository", vim.log.levels.WARN)
			end
		end, { desc = "Fuzzy find git files" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		-- shortcut for searching your Neovim configuration files
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find in Neovim files" })
	end,
}
