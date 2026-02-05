return {
	"laytan/cloak.nvim",
	event = "BufRead",
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			patterns = {
				{
					file_pattern = {
						".env*",
						"wrangler.toml",
						".dev.vars",
					},
					cloak_pattern = "=.+",
				},
			},
		})

		-- Disable cloaking for example files
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = { "*.example", "*.sample" },
			callback = function()
				local ns = vim.api.nvim_get_namespaces()["cloak"]
				if ns then
					vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
				end
			end,
		})
	end,
}
