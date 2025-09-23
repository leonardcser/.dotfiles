return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- LSP progress tracking
		local lsp_progress = {
			client_name = "",
			message = "",
			percentage = 0,
			is_active = false,
		}

		-- Handler for LSP progress
		vim.api.nvim_create_autocmd("LspProgress", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client then
					lsp_progress.client_name = client.name
					lsp_progress.message = args.data.params.value.message or ""
					lsp_progress.percentage = args.data.params.value.percentage or 0
					lsp_progress.is_active = args.data.params.value.kind ~= "end"

					-- Refresh status line
					vim.cmd("redrawstatus")
				end
			end,
		})

		local colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = my_lualine_theme,
				-- section_separators = "",
				-- component_separators = "",
				refresh = {
					statusline = 50,
					tabline = 50,
					winbar = 50,
				},
			},
			sections = {
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					{
						function()
							if lsp_progress.is_active then
								local spinner_frames =
									{ "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
								local frame_index = math.floor(vim.fn.reltimestr(vim.fn.reltime()) * 10)
										% #spinner_frames
									+ 1
								local spinner = spinner_frames[frame_index]

								local display = string.format("%s %s", spinner, lsp_progress.client_name)
								if lsp_progress.message and lsp_progress.message ~= "" then
									display = display .. ": " .. lsp_progress.message
								end
								if lsp_progress.percentage > 0 then
									display = display .. string.format(" (%d%%)", lsp_progress.percentage)
								end
								return display
							end
							return ""
						end,
						cond = function()
							return lsp_progress.is_active
						end,
						color = { fg = colors.yellow },
					},
					{
						function()
							return require("wpm-tracker").get_wpm_display()
						end,
						cond = function()
							return require("wpm-tracker").get_current_wpm() > 0
						end,
						color = { fg = colors.green },
					},
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
