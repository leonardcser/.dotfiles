return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local nts = require("nvim-treesitter")
		nts.setup({})

		vim.api.nvim_create_autocmd("FileType", {
			desc = "Start treesitter and install parser if missing",
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end
				if not vim.list_contains(nts.get_available(), lang) then
					return
				end
				if not vim.list_contains(nts.get_installed(), lang) then
					nts.install(lang):wait(300000)
				end
				vim.treesitter.start(args.buf, lang)
			end,
		})

		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
			per_filetype = {
				["html"] = {
					enable_close = false,
				},
			},
		})
	end,
}
