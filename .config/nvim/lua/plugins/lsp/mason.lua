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
		local lspconfig = require("lspconfig")

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
			root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
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

		local servers = {
			"ts_ls",
			"rust_analyzer",
			"html",
			"cssls",
			"tailwindcss",
			"lua_ls",
			"emmet_ls",
			"prismals",
			"svelte",
			"jdtls",
			"clangd",
			"ruff",
			"pyright",
			"dockerls",
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
			},
		})

		-- Disable ruff hover in favor of pyright
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
