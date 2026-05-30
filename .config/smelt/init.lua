-- Providers
--
-- Models can be a bare string or a table with per-model overrides:
--   { "model-name", temperature = 0.7, top_p = 0.9, ... }
-- Known fields: name, temperature, top_p, top_k, min_p, repeat_penalty,
-- tool_calling, input_cost, output_cost, cache_read_cost, cache_write_cost.

smelt.provider.register("zai", {
	type = "openai-compatible",
	api_base = "https://api.z.ai/api/coding/paas/v4",
	api_key_env = "Z_AI_API_KEY",
	models = { "glm-4.7" },
})

smelt.provider.register("box", {
	type = "openai-compatible",
	api_base = "https://llm.box.home.arpa",
	api_key_env = "BOX_API_KEY",
	models = {
		{
			name = "Qwen/Qwen3.6-27B",
			temperature = 0.6,
			top_p = 0.95,
			top_k = 20,
			min_p = 0.0,
			repeat_penalty = 1.0,
		},
		{
			name = "Qwen/Qwen3.6-35B-A3B",
			temperature = 0.6,
			top_p = 0.95,
			top_k = 20,
			min_p = 0.0,
			repeat_penalty = 1.0,
		},
		"openai/gpt-oss-20b",
	},
})

smelt.provider.register("kimi-code", {
	type = "anthropic-compatible",
	api_base = "https://api.kimi.com/coding/v1",
	api_key_env = "KIMI_CODE_API_KEY",
	models = { "kimi-k2.6" },
})

smelt.provider.register("cloudflare", {
	type = "openai-compatible",
	api_base = "https://api.cloudflare.com/client/v4/accounts/2c5064c9595fe36f17aab3533cdd55ff/ai/v1",
	api_key_env = "CLOUDFLARE_AUTH_TOKEN",
	models = { "@cf/moonshotai/kimi-k2.6" },
})

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

-- MCP servers
smelt.mcp.register("nvim_lsp", {
	command = { "/Users/leo/dev/mcp/nvim-lsp-mcp/nvim-lsp-mcp" },
})

-- Permissions
--
-- Mode keys: default (cross-mode baseline), normal, plan, apply, yolo.
-- Inside each mode, `tools = { allow/ask/deny }` is the per-tool list;
-- every other key is a per-tool subpattern bucket (e.g. `bash`,
-- `web_fetch`, `mcp`, or any custom-named tool).
smelt.permissions.set_rules({
	default = {
		web_fetch = { allow = { "*" } },
		tools = { allow = { "web_search" } },
		mcp = { allow = { "nvim_lsp_read_lints" } },
	},
})

-- Settings — boolean preferences. Defaults shown; uncomment to override.
smelt.settings.vim = true
-- smelt.settings.auto_compact = false         -- compact context when full
-- smelt.settings.show_tps = true              -- tokens/sec in statusline
-- smelt.settings.show_tokens = true           -- token usage in statusline
-- smelt.settings.show_cost = true             -- session cost in statusline
smelt.settings.show_prediction = false -- ghost-text input prediction
-- smelt.settings.show_slug = true             -- task slug pill in statusline
-- smelt.settings.show_thinking = true         -- render thinking blocks
-- smelt.settings.restrict_to_workspace = true -- block tool writes outside cwd
smelt.settings.redact_secrets = false -- strip secrets before LLM
--
smelt.settings.autoupgrade = "notify"
smelt.settings.autoupgrade_channel = "unstable"

-- Demo: snake game (F11 to toggle, or `:snake`).
require("smelt.examples.snake")
require("smelt.examples.diff")
require("smelt.examples.banner_picker")
