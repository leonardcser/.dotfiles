return {
	"williamboman/mason.nvim",
	event = { "VeryLazy" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

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

	local servers = {
			"ts_ls",
			"rust_analyzer",
			"zls",
			"html",
			"cssls",
			"tailwindcss",
			"lua_ls",
			"emmet_ls",
			"prismals",
			"svelte",
			"astro",
			"jdtls",
			"clangd",
			"ruff",
			"pyright",
			-- "pyrefly",
			"dockerls",
			"beancount",
		}

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = servers,
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"prettierd",
				"stylua",
				"eslint_d",
				"clang-format",
				"typstyle",
			},
		})

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
