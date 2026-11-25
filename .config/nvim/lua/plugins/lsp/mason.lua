return {
	"williamboman/mason.nvim",
	event = "User Dev",
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
			cmd = {
				vim.fn.expand("~/dev/thirdparty/beancount-language-server/target/release/beancount-language-server"),
			},
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

		local lsp_enabled = true
		vim.lsp.enable(servers)
		vim.keymap.set("n", "<leader>la", function()
			lsp_enabled = not lsp_enabled
			vim.lsp.enable(servers, lsp_enabled)
			if not lsp_enabled then
				require("config.statusline").clear_progress()
			end
			vim.notify(lsp_enabled and "LSP enabled" or "LSP disabled", vim.log.levels.INFO)
		end, { desc = "Toggle LSP" })

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
