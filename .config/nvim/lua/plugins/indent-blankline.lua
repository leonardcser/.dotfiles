return {
	"lukas-reineke/indent-blankline.nvim",
	event = "User Dev",
	cmd = "IBLEnable",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		indent = {
			char = "│",
		},
	},
}
