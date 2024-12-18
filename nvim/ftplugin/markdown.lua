-- Markdown preview
local peek = require("peek")

vim.keymap.set("n", "<leader>p", function()
	if peek.is_open() then
		peek.close()
	else
		peek.open()
	end
end, { desc = "Toggle markdown preview" })
