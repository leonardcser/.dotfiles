-- Providers
--
-- Models can be a bare string or a table with per-model overrides:
--   { "model-name", temperature = 0.7, top_p = 0.9, ... }
-- Known fields: name, temperature, top_p, top_k, min_p, repeat_penalty,
-- tool_calling, input_cost, output_cost, cache_read_cost, cache_write_cost.

-- smelt.provider.register("zai", {
-- 	type = "openai-compatible",
-- 	api_base = "https://api.z.ai/api/coding/paas/v4",
-- 	api_key_env = "Z_AI_API_KEY",
-- 	models = { "glm-4.7" },
-- })

smelt.provider.register("box", {
	type = "openai-compatible",
	api_base = "https://llm.home.devleo.ch/v1",
	api_key_env = "BOX_API_KEY",
	models = {
		{
			name = "Qwen/Qwen3.8-27B-FP8",
			temperature = 0.6,
			top_p = 0.95,
			top_k = 20,
			min_p = 0.0,
			repeat_penalty = 1.0,
		},
		{
			name = "orcarouter/Qwen3.8-27B-Uncensored-NVFP4",
			supports_reasoning = true,
			supported_reasoning_efforts = { "off", "low", "medium", "xhigh" },
			default_reasoning_effort = "xhigh",
			temperature = 0.6,
			top_p = 0.95,
			top_k = 20,
			min_p = 0.0,
			repeat_penalty = 1.0,
		},
		-- {
		-- 	name = "orcarouter/Qwen3.8-Flash-Next-Uncensored-GGUF:Q4_K_M",
		-- 	temperature = 0.6,
		-- 	top_p = 0.95,
		-- 	top_k = 20,
		-- 	min_p = 0.0,
		-- 	repeat_penalty = 1.0,
		-- },
	},
})

smelt.provider.register("as", {
	type = "openai-compatible",
	api_base = "https://litellm.hackathon.intlab.ch",
	api_key_env = "AS_API_KEY",
	models = {
		{
			name = "Qwen/Qwen3.8-Flash-Next",
			temperature = 0.4,
			top_p = 0.95,
			top_k = 20,
			min_p = 0.0,
			repeat_penalty = 1.0,
		},
	},
})

-- smelt.provider.register("cloudflare", {
-- 	type = "openai-compatible",
-- 	api_base = "https://api.cloudflare.com/client/v4/accounts/2c5064c9595fe36f17aab3533cdd55ff/ai/v1",
-- 	api_key_env = "CLOUDFLARE_AUTH_TOKEN",
-- 	models = { "@cf/moonshotai/kimi-k2.6" },
-- })

smelt.provider.register("iict", {
	type = "openai-compatible",
	api_base = "https://k8s-ray.iict-heig-vd.in/v1",
	models = {
		"Qwen/Qwen3.5-27B",
		"Qwen/Qwen3.5-122B-A10B-FP8",
	},
})

smelt.provider.register("codex", {
	type = "codex",
	api_base = "https://chatgpt.com/backend-api/codex",
})

smelt.provider.register("copilot", {
	type = "copilot",
	api_base = "https://api.individual.githubcopilot.com",
})

-- Opt-in plugins
-- require("smelt.plugins.subagents")
require("smelt.plugins.which_key")
require("smelt.plugins.goal")
require("smelt.plugins.show_ansi")
require("smelt.plugins.plot")
require("smelt.plugins.lsp").setup({
	start = "background",
	servers = {
		["rust-analyzer"] = {
			cmd = { "rust-analyzer" },
			extensions = { "rs" },
			language_id = "rust",
			root_markers = { "Cargo.toml", "rust-project.json", ".git" },
		},
	},
})

-- Keymaps
smelt.keymap.set_leader("<space>")
smelt.keymap.set("n", "<leader>r", function()
	smelt.cmd.run("resume")
end, { desc = "resume session" })

-- MCP servers
-- smelt.mcp.register("nvim_lsp", {
-- 	command = { "/Users/leo/dev/mcp/nvim-lsp-mcp/nvim-lsp-mcp" },
-- })

-- Permissions
--
-- Path rules apply in every mode. The workspace and temp dirs are
-- already "allow" by default.
smelt.permissions.paths({ ["~/.cargo"] = "allow" })

-- Tools that run without asking in every mode.
local always_allow = {
	web_search = true,
	web_fetch = true,
	nvim_lsp_read_lints = true,
	-- Claude Code's Agent is "full". Its subagent's tool calls still go
	-- through this policy.
	Agent = true,
	-- Claude Code's SendMessage is "full" because it can also reach other
	-- sessions. Allow it like Agent.
	SendMessage = true,
}
-- Claude Code's own Bash runs outside smelt's sandbox, so smelt counts it as
-- "full". In write mode, run it without asking anyway.
local function claude_code_bash_in_write(call)
	if call.tool ~= "bash" or call.mode.name ~= "write" then
		return false
	end
	local ok, model = pcall(smelt.model.current)
	return ok and model ~= nil and model:find("^claude%-code/") ~= nil
end

local check = smelt.permissions.check
smelt.permissions.check = function(call)
	if always_allow[call.tool] or claude_code_bash_in_write(call) then
		return "allow"
	end
	return check(call)
end

-- Settings — boolean preferences. Defaults shown; uncomment to override.
smelt.settings.vim = true
-- smelt.settings.auto_compact = false         -- compact context when full
-- smelt.settings.show_tps = true              -- tokens/sec in statusline
-- smelt.settings.show_tokens = true           -- token usage in statusline
-- smelt.settings.show_cost = true             -- session cost in statusline
smelt.settings.show_prediction = false -- ghost-text input prediction
-- smelt.settings.show_slug = true             -- task slug pill in statusline
-- smelt.settings.show_thinking = true         -- render thinking blocks
smelt.settings.autoupgrade_channel = "unstable"
smelt.settings.file_icons = true

-- Statusline: save the theme's accent pill for managed worktrees.
local session_pill_bg = 245
local slug = smelt.statusline:builtin("slug")
smelt.statusline:add("slug", {
	signals = slug.signals,
	render = function(ctx)
		local item = slug.render(ctx)
		local worktree = smelt.signal.get("cwd_worktree")
		local in_worktree = smelt.signal.get("cwd_managed_worktree") and worktree and worktree ~= ""
		if item and not in_worktree then
			item.style = { hl_group = "SmeltSlug", bg = session_pill_bg }
		end
		return item
	end,
})

-- File finder keymaps
smelt.keymap.set("n", "<leader>ff", function()
	smelt.cmd.run("files all")
end, { desc = "find all files" })
smelt.keymap.set("n", "<leader>fg", function()
	smelt.cmd.run("files git")
end, { desc = "find git files" })
smelt.keymap.set("n", "<leader>fs", function()
	smelt.cmd.run("search all")
end, { desc = "search all file contents" })
