return {
	"toppair/peek.nvim",
	cmd = { "PeekOpen", "PeekClose" },
	keys = {
		{
			"<leader>p",
			function()
				local peek = require("peek")
				if peek.is_open() then
					peek.close()
				else
					peek.open()
				end
			end,
			ft = "markdown",
			desc = "Toggle markdown preview",
		},
	},
	build = "deno task --quiet build:fast",
	config = function()
		require("peek").setup()
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	end,
}
