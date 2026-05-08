return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
			"Vigemus/iron.nvim",
		},
		ft = { "quarto", "markdown" },
		opts = {
			lspFeatures = {
				enabled = true,
				chunks = "curly",
				languages = { "r", "python", "julia", "bash", "html" },
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = true,
				default_method = "iron",
				ft_runners = {},
				never_run = { "yaml" },
			},
		},
		keys = {
			{
				"<leader>rc",
				function()
					require("quarto.runner").run_cell()
				end,
				desc = "run cell",
			},
			{
				"<leader>ra",
				function()
					require("quarto.runner").run_above()
				end,
				desc = "run cell and above",
			},
			{
				"<leader>rb",
				function()
					require("quarto.runner").run_below()
				end,
				desc = "run cell and below",
			},
			{
				"<leader>rA",
				function()
					require("quarto.runner").run_all()
				end,
				desc = "run all cells",
			},
			{
				"<leader>rl",
				function()
					require("quarto.runner").run_line()
				end,
				desc = "run line",
			},
			{
				"<leader>r",
				function()
					require("quarto.runner").run_range()
				end,
				mode = "v",
				desc = "run visual range",
			},
			{
				"<leader>RA",
				function()
					require("quarto.runner").run_all(true)
				end,
				desc = "run all cells of all languages",
			},
		},
	},
	{
		"Vigemus/iron.nvim",
		keys = {
			{
				"<leader>rt",
				function()
					require("iron.core").repl_for("r")
				end,
				desc = "toggle R repl",
			},
			{
				"<leader>rR",
				function()
					require("iron.core").repl_restart()
				end,
				desc = "restart repl",
			},
		},
		config = function()
			local view = require("iron.view")
			local common = require("iron.fts.common")
			require("iron.core").setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						r = { command = { "R", "--no-save" }, format = common.bracketed_paste_python },
						python = { command = { "python3" }, format = common.bracketed_paste_python },
						sh = { command = { "bash" } },
					},
					repl_open_cmd = view.split.vertical.botright(60),
				},
			})
		end,
	},
}
