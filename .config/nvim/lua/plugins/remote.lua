return {
	"amitds1997/remote-nvim.nvim",
	version = "*",
	cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("remote-nvim").setup({
			client_callback = function(port, workspace_config)
				local cmd = ("tmux new-window -n '%s [remote]' 'nvim --server localhost:%s --remote-ui'"):format(
					workspace_config.host,
					port
				)
				vim.fn.jobstart(cmd, {
					detach = true,
					on_exit = function(job_id, exit_code, event_type)
						print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
					end,
				})
			end,
		})
	end,
}
