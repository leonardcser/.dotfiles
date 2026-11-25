local M = {}

--- Run `fn` now in a Dev session, or once `:Dev` enables one.
function M.on(fn)
	if vim.g.dev_mode then
		fn()
	else
		vim.api.nvim_create_autocmd("User", {
			pattern = "Dev",
			once = true,
			callback = function()
				fn()
			end,
		})
	end
end

--- Load `plugin` for the first buffer of `filetypes` in a Dev session.
function M.load_on_filetype(plugin, filetypes)
	M.on(function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			once = true,
			callback = function(ev)
				require("lazy").load({ plugins = { plugin } })
				-- Run the new ftplugin and FileType handlers for this buffer.
				vim.api.nvim_exec_autocmds("FileType", { buffer = ev.buf, modeline = false })
			end,
		})
	end)
end

function M.enable()
	if vim.g.dev_mode then
		return
	end
	vim.g.dev_mode = true
	vim.cmd("filetype plugin indent on")
	vim.api.nvim_exec_autocmds("User", { pattern = "Dev", modeline = false })

	-- Apply filetype helpers to open files without re-reading unsaved text.
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "" then
			vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
		end
	end
end

return M
