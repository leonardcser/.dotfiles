return {
	"nvim-treesitter/nvim-treesitter",
	event = "User Dev",
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

		local function install_parser(lang, on_ready)
			if pending_installs[lang] then
				if on_ready then
					table.insert(pending_installs[lang], on_ready)
				end
				return
			end
			if not vim.list_contains(nts.get_available(), lang) then
				return
			end
			pending_installs[lang] = { on_ready }
			nts.install(lang):await(function(err, ok)
				local callbacks = pending_installs[lang]
				pending_installs[lang] = nil
				if not err and ok then
					for _, callback in ipairs(callbacks) do
						vim.schedule(callback)
					end
				end
			end)
		end

		local installed = nts.get_installed()
		for _, lang in ipairs(bootstrap_langs) do
			if not vim.list_contains(installed, lang) then
				install_parser(lang)
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			desc = "Start treesitter and install parser if missing",
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end
				if vim.treesitter.language.add(lang) then
					vim.treesitter.start(args.buf, lang)
				else
					install_parser(lang, function()
						if vim.api.nvim_buf_is_loaded(args.buf) and vim.bo[args.buf].filetype == args.match then
							vim.treesitter.start(args.buf, lang)
						end
					end)
				end
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
