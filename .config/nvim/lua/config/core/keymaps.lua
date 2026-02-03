-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- General Keymaps -------------------
-- disable moving up and down
vim.api.nvim_set_keymap("", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<Right>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Right>", "<Nop>", { noremap = true, silent = true })

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
-- keymap.set("n", "x", '"_x')

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

-- Git keymaps
keymap.set("n", "<leader>gi", ":Git init<CR>", { desc = "Initialize git repository" })
keymap.set("n", "<leader>go", ":Git open<CR>", { desc = "Open git repository" })
keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Show git log" })
keymap.set("n", "<leader>gp", ":Git push origin<CR>", { desc = "Push git changes" })
keymap.set("n", "<leader>gP", ":Git pull --rebase --prune<CR>", { desc = "Pull git changes" })
keymap.set("n", "<leader>ga", ":Git add -u<CR>", { desc = "Add git changes" })
keymap.set("n", "<leader>gf", ":Git push --force-with-lease<CR>", { desc = "Push git changes (force-with-lease)" })
keymap.set("n", "<leader>gr", function()
	local output = vim.fn.system("git rev-list --count HEAD 2>/dev/null"):gsub("\n", "")
	local commit_count = tonumber(output) or 0
	if commit_count <= 6 then
		vim.cmd("Git rebase -i --root")
	else
		vim.cmd("Git rebase -i HEAD~6")
	end
end, { desc = "Interactive git rebase" })
local copy_cmd = vim.fn.has("mac") == 1 and "pbcopy" or "xclip -selection clipboard"

keymap.set("n", "<leader>gu", function()
	local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
	if remote_url == "" then
		print("No remote URL found.")
		return
	end
	vim.fn.system(string.format("echo -n '%s' | %s", remote_url, copy_cmd))
	print("Copied remote URL: " .. remote_url)
end, { desc = "Copy remote git URL" })

-- Quickfix list keymaps
keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
keymap.set("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
keymap.set("n", "<leader>qf", "<cmd>cfirst<CR>", { desc = "First quickfix item" })
keymap.set("n", "<leader>ql", "<cmd>clast<CR>", { desc = "Last quickfix item" })

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

-- Make current file executable
keymap.set("n", "<leader>ex", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable" })

-- Spelling keymaps
keymap.set("n", "<leader>sp", "a<C-X>s", { desc = "Show spelling suggestions" })

-- Search selected text in browser
keymap.set("v", "<leader>o", function()
	-- Get the selected text
	vim.cmd('noau normal! "vy"')
	local selected_text = vim.fn.getreg("v")

	-- URL encode the text
	local encoded_text = selected_text:gsub("([^%w%-%.%_%~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)

	-- Open browser with DuckDuckGo search query
	local search_url = string.format("https://duckduckgo.com/?q=%s", encoded_text)
	vim.fn.system(string.format("open %s", vim.fn.shellescape(search_url)))
end, { desc = "Search selected text in browser" })
