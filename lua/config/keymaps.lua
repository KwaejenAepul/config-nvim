vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", {desc="Open Parent Directory in Oil"})
vim.keymap.set('t', '<C-space>', '<C-\\><C-n><C-w>h',{silent = true}, { desc = 'Exit terminal mode' })

-- todo keymaps
vim.keymap.set("n","<leader>td", ":TodoQuickFix<CR>", {desc="Open todos quickfix list"})
vim.keymap.set("n","<leader>tl", ":TodoLocList<CR>", {desc="Open todos location list"})
--easier window focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- snack keybinds
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, {desc = "Buffers"})
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, {desc = "Find Files"})
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, {desc = "Find Git Files"})
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, {desc = "Projects"})
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, {desc = "Recent"})
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, {desc = "Grep Open Buffers"})
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.git_files() end, {desc = "Grep"})
-- LSP
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, {desc = "Goto Definition"})
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, {desc = "Goto Declaration"})
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, {desc = "References"})
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, {desc = "Goto Implementation"})
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, {desc = "Goto T[y]pe Definition"})
vim.keymap.set("n","<leader>cr", vim.lsp.buf.rename, {desc ='[R]e[n]ame'})
-- Terminal
vim.keymap.set("n","<F12>", function() Snacks.terminal.toggle() end, {desc = "toggle terminal"})

-- move line or selection
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

--yank and paste from system clipboard
vim.keymap.set('n', '<leader>p', '"+p')  -- paste after cursor
vim.keymap.set('n', '<leader>P', '"+P')  -- paste before cursor
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y') -- yank motion
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y') -- yank line
