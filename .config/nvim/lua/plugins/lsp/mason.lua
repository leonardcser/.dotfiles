return {
	"williamboman/mason.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local mason = require("mason")

		-- Configure servers using the new vim.lsp.config() API
		vim.lsp.config("cssls", {
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				scss = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
				less = {
					validate = true,
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		})

		vim.lsp.config("ts_ls", {
			root_dir = function(bufnr, on_dir)
				local root_markers = {
					"tsconfig.json",
					"jsconfig.json",
					"package-lock.json",
					"yarn.lock",
					"pnpm-lock.yaml",
					"bun.lockb",
					"bun.lock",
				}
				local project_root = vim.fs.root(bufnr, root_markers)
				if not project_root then
					project_root = vim.fn.getcwd()
				end
				on_dir(project_root)
			end,
			single_file_support = true,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						},
						checkThirdParty = false,
					},
					completion = { callSnippet = "Replace" },
					telemetry = { enable = false },
				},
			},
		})

		vim.lsp.config("emmet_ls", {
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

			vim.lsp.config("beancount", {
			cmd = { vim.fn.expand("~/dev/thirdparty/beancount-language-server/target/release/beancount-language-server") },
			init_options = {
				journal_file = vim.fn.getcwd() .. "/main.beancount",
			},
		})

		-- Biome LSP: only activate if biome.json exists in project root
		vim.lsp.config("biome", {
			root_dir = function(bufnr, on_dir)
				local root = vim.fs.root(bufnr, { "biome.json", "biome.jsonc" })
				if root then
					on_dir(root)
				end
				-- Returns nil if no biome.json, preventing LSP from starting
			end,
			single_file_support = false,
		})

		local servers = require("config.servers")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- bigfile.nvim clears the filetype after detection. Veto activation before
		-- a server can start for the transient filetype, not after LspAttach.
		for _, name in ipairs(servers) do
			local root_dir = vim.lsp.config[name].root_dir
			vim.lsp.config(name, {
				root_dir = function(bufnr, on_dir)
					if vim.b[bufnr].bigfile_detected == 1 then
						return
					end
					if type(root_dir) == "function" then
						return root_dir(bufnr, on_dir)
					end
					on_dir(root_dir) -- nil preserves native root_markers lookup
				end,
			})
		end

		if vim.g.lsp_enabled then
			vim.lsp.enable(servers)
		end

		-- Disable ruff hover in favor of python lsp
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "ruff" then
					client.server_capabilities.hoverProvider = false
				end
			end,
		})
	end,
}
