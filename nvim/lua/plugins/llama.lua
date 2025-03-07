return {
	"ggml-org/llama.vim",
	config = function()
		vim.g.llama_config = {
			endpoint = "http://127.0.0.1:8012/infill",
			api_key = "",
			n_prefix = 256,
			n_suffix = 64,
			n_predict = 64,
			t_max_prompt_ms = 250,
			t_max_predict_ms = 250,
			show_info = 0,
			auto_fim = true,
			max_line_suffix = 8,
			max_cache_keys = 250,
			ring_n_chunks = 16,
			ring_chunk_size = 65,
			ring_scope = 1024,
			ring_update_ms = 1000,
		}
		-- Override the highlight settings
		vim.api.nvim_set_hl(0, "llama_hl_hint", { fg = "#81A1C1" })
		vim.api.nvim_set_hl(0, "llama_hl_info", { fg = "#00ff00" })

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>lt", ":LlamaToggle<CR>", { desc = "Toggle LLM Completions" })
	end,
}
