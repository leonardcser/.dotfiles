-- Csv preview
vim.keymap.set("n", "<leader>p", function()
    vim.cmd(":CsvViewToggle")
end, { desc = "Toggle csv preview" })
