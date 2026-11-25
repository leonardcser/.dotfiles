return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	cmd = { "MasonToolsInstall", "MasonToolsInstallSync", "MasonToolsUpdate", "MasonToolsUpdateSync", "MasonToolsClean" },
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			cmd = { "LspInstall", "LspUninstall" },
			dependencies = { "williamboman/mason.nvim" },
			opts = { automatic_enable = false },
		},
	},
	opts = function()
		local tools = { "prettier", "prettierd", "stylua", "eslint_d", "clang-format", "typstyle" }
		-- Biome provides both an LSP and a formatter; config.servers already includes it.
		return { ensure_installed = vim.list_extend(tools, require("config.servers")), run_on_start = false }
	end,
}
