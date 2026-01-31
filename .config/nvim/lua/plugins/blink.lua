return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	version = "*",
	opts = {
		keymap = {
			preset = "default",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-y>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
		},
		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},
		completion = {
			menu = {
				auto_show = true,
			},
		},
		sources = {
			-- 	default = { "cursortab", "lsp", "path", "snippets", "buffer" },
			-- 	providers = {
			-- 		cursortab = {
			-- 			module = "cursortab.blink",
			-- 			name = "Cursortab",
			-- 			score_offset = 1000,
			-- 			-- async = true,
			-- 		},
			-- 	},
		},
	},
	opts_extend = { "sources.default" },
}
