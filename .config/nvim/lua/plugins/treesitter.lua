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
		local pending_installs = {}
		local bootstrap_langs = { "lua", "vim", "vimdoc", "query" }

		local function ensure_parser(lang, on_ready)
			if not vim.list_contains(nts.get_available(), lang) then
				return
			end
			if vim.list_contains(nts.get_installed(), lang) then
				if on_ready then
					on_ready()
				end
				return
			end
			if pending_installs[lang] then
				return
			end

			pending_installs[lang] = true
			nts.install(lang):await(function(err, ok)
				pending_installs[lang] = nil
				if err or not ok then
					return
				end
				if on_ready then
					vim.schedule(on_ready)
				end
			end)
		end

		for _, lang in ipairs(bootstrap_langs) do
			ensure_parser(lang)
		end

		vim.api.nvim_create_autocmd("FileType", {
			desc = "Start treesitter and install parser if missing",
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end
				ensure_parser(lang, function()
					if vim.api.nvim_buf_is_valid(args.buf) then
						vim.treesitter.start(args.buf, lang)
					end
				end)
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
