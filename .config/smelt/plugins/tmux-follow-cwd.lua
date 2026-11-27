local tmux_socket = smelt.os.getenv("TMUX")
local pane = smelt.os.getenv("TMUX_PANE")
if not smelt.frontend.is_interactive() or not tmux_socket or tmux_socket == "" or not pane or not pane:match("^%%%d+$") then
	return
end

local function tmux(args)
	return smelt.process.capture("tmux", args, { env = { TMUX = tmux_socket }, timeout_secs = 5 })
end

local function warn(step, err)
	smelt.log.warn("tmux_follow_cwd_failed", { step = step, error = err })
end

local function trim(text)
	return (text:gsub("%s+$", ""))
end

-- Clients that show `session`, when the pane's window is the one they look at.
local function viewing_clients(session, window_active)
	if window_active ~= "1" then
		return {}
	end
	local listed = tmux({ "list-clients", "-F", "#{client_name}\t#{client_session}" })
	local clients = {}
	for line in (listed or ""):gmatch("[^\n]+") do
		local client, client_session = line:match("^(.-)\t(.*)$")
		if client and client_session == session then
			table.insert(clients, client)
		end
	end
	return clients
end

-- Breaks the pane into its own window at the end of `target`. The clients that looked at the
-- pane follow it; the others stay where they are.
local function move_pane(target, clients, step)
	local window, err = tmux({ "break-pane", "-a", "-d", "-P", "-F", "#{window_id}", "-s", pane, "-t", target .. "{end}" })
	if not window then
		return warn(step, err)
	end
	if #clients == 0 then
		return true
	end
	local selected, select_err = tmux({ "select-window", "-t", trim(window) })
	if not selected then
		return warn("select", select_err)
	end
	for _, client in ipairs(clients) do
		local switched, switch_err = tmux({ "switch-client", "-c", client, "-t", target })
		if not switched then
			warn("switch", switch_err)
		end
	end
	return true
end

local function follow_root(root)
	local base = smelt.path.basename(root)
	if not base then
		return
	end
	-- Same naming rule as tmux-sessionizer.
	local name = base:gsub("%.", "_")

	local source, err = tmux({
		"display-message", "-p", "-t", pane,
		"#{session_name}\t#{window_panes}\t#{session_windows}\t#{session_path}\t#{window_active}",
	})
	if not source then
		return warn("inspect", err)
	end
	local current, panes, windows, source_path, window_active = source:match("^(.-)\t(%d+)\t(%d+)\t(.-)\t(%d)")
	-- Moving the last pane of the last window would close the source session.
	if not current or current == name or (panes == "1" and windows == "1") then
		return
	end
	local clients = viewing_clients(current, window_active)

	local target = "=" .. name .. ":"
	-- `has-session` exits non-zero when no session has this name.
	if tmux({ "has-session", "-t", "=" .. name }) then
		local path = tmux({ "display-message", "-p", "-t", target, "#{session_path}" })
		if path and smelt.path.canonical(path) == root then
			move_pane(target, clients, "move_existing")
		end
		return
	end

	-- A root inside the source session (a worktree of its project) stays in it.
	local session_root = smelt.path.canonical(source_path)
	if session_root and (root == session_root or root:sub(1, #session_root + 1) == session_root .. "/") then
		return
	end

	-- A new project: create its session, move the pane in, and drop the session's blank window.
	local blank, create_err = tmux({ "new-session", "-d", "-P", "-F", "#{window_id}", "-s", name, "-c", root })
	if not blank then
		return warn("create", create_err)
	end
	if not move_pane(target, clients, "move_new") then
		return
	end
	local killed, kill_err = tmux({ "kill-window", "-t", trim(blank) })
	if not killed then
		warn("kill_blank", kill_err)
	end
end

smelt.signal.subscribe("cwd_root", function(root, previous)
	-- Only follow changes made during the session, not the initial root.
	if not previous or previous == "" then
		return
	end
	smelt.spawn(function()
		follow_root(root)
	end)
end)
