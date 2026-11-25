local env_files = { ".env*", "wrangler.toml", ".dev.vars" }
local secret_files = { "*secret*.yml", "*secret*.yaml" }
local files = table.concat(vim.list_extend(vim.list_extend({}, env_files), secret_files), ",")

return {
	"laytan/cloak.nvim",
	-- Load before secret files are shown, and only for them.
	event = { "BufReadPre " .. files, "BufNewFile " .. files },
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			patterns = {
				{
					file_pattern = env_files,
					cloak_pattern = "(=[\"']?)[^\"']+",
					replace = "%1",
				},
				{
					file_pattern = secret_files,
					cloak_pattern = "(:%s?[\"']?)[^\"']+",
					replace = "%1",
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
