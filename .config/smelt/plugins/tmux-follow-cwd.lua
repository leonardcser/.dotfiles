-- When this agent's project root changes during the session, agent-mux moves
-- its tmux pane to the workspace of the new project, and the clients that
-- show the pane follow it. agent-mux decides where the pane belongs: the
-- session of the project's main checkout, restored when dormant, made when
-- missing.
local tmux_socket = smelt.os.getenv("TMUX")
local pane = smelt.os.getenv("TMUX_PANE")
if not smelt.frontend.is_interactive() or not tmux_socket or tmux_socket == "" or not pane or not pane:match("^%%%d+$") then
	return
end

smelt.signal.subscribe("cwd_root", function(root, previous)
	-- Only follow changes made during the session, not the initial root.
	if not previous or previous == "" then
		return
	end
	smelt.spawn(function()
		local moved, err = smelt.process.capture("agent-mux", { "move", pane, root }, {
			env = { TMUX = tmux_socket },
			timeout_secs = 10,
		})
		if not moved then
			smelt.log.warn("tmux_follow_cwd_failed", { error = err })
		end
	end)
end)
