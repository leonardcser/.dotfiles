return {
	"catgoose/nvim-colorizer.lua",
	name = "catgoose-colorizer",
	main = "colorizer",
	-- Load after the first screen draw, then color the buffers already open.
	event = "VeryLazy",
	opts = {
		filetypes = { "*", "!bigfile" },
	},
	config = function(_, opts)
		require("colorizer").setup(opts)
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) then
				vim.api.nvim_exec_autocmds("FileType", { group = "ColorizerSetup", buffer = buf, modeline = false })
			end
		end
	end,
}
