-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- General Keymaps -------------------
-- disable moving up and down
vim.api.nvim_set_keymap("", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<Right>", "<Nop>", { noremap = true, silent = true })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection up" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection down" })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor to the middle" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep cursor to the middle" })
keymap.set("n", "n", "nzzzv", { desc = "Keep cursor to the middle" })
keymap.set("n", "N", "Nzzzv", { desc = "Keep cursor to the middle" })

-- copy and paste
keymap.set("x", "<leader>p", '"_dP')

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Function to toggle diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	local current_value = vim.diagnostic.is_enabled()
	if current_value then
		vim.diagnostic.enable(false)
	else
		vim.diagnostic.enable()
	end
end, {})

keymap.set(
	"n",
	"<leader>mt",
	'<cmd>lua vim.cmd("DiagnosticsToggle")<CR>',
	{ desc = "Toggle inline diagnostics", noremap = true, silent = true }
)
