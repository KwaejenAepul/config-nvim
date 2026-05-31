vim.loader.enable()

--helper function for plugins hosted on github
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add{gh 'nvim-lua/plenary.nvim',
            gh 'nvim-tree/nvim-web-devicons',
            gh 'sindrets/diffview.nvim',
            gh 'folke/todo-comments.nvim',
            gh 'tpope/vim-sleuth',
            gh 'windwp/nvim-autopairs',
            gh 'echasnovski/mini.statusline',
            gh 'NeogitOrg/neogit',
            gh 'stevearc/oil.nvim',
            gh 'folke/snacks.nvim'}

vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
--colortheme
vim.pack.add {gh 'folke/tokyonight.nvim'}
vim.cmd[[colorscheme tokyonight-night]]

--Godot stuff
local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end

vim.pack.add{gh 'hrsh7th/cmp-nvim-lsp'}
vim.pack.add{'https://github.com/hrsh7th/nvim-cmp'}
--autocomplete & snippits
  require('luasnip').setup {}
  -- [[ Autocomplete Engine ]]
  require('blink.cmp').setup {
    keymap = {
     preset = 'default',
     ["<Tab>"] = {"accept", "fallback"}
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', "buffer" },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  }

require('cmp').setup {enable = true}
--LSP yoinked from kickstart.nvim 
--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

 
  end,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
   clangd = {},
   gdtoolkit={},
   glsl_analyzer = {},
   pyright = {},
   rust_analyzer = {},
   marksman = {},
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},

  stylua = {}, -- Used to format Lua code

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
}

vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.lsp.enable("gdscript",{capabilities={capabilities}})
-- Automatically install LSPs and related tools to stdpath for Neovim
require('mason').setup {}

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  -- You can add other tools here that you want Mason to install
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end


---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  -- Enable treesitter based indentation
  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

vim.diagnostic.config {
    severity_sort = true,
    underline = true, --{ severity = vim.diagnostic.severity.ERROR },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    },
    virtual_text = false,--{
    --    source = 'if_many',
    --    spacing = 2,
    --    format = function(diagnostic)
    --      local diagnostic_message = {
    --        [vim.diagnostic.severity.ERROR] = diagnostic.message,
    --        [vim.diagnostic.severity.WARN] = diagnostic.message,
    --        [vim.diagnostic.severity.INFO] = diagnostic.message,
    --        [vim.diagnostic.severity.HINT] = diagnostic.message,
    --      }
    --      return diagnostic_message[diagnostic.severity]
    --    end,
    --  },
}
--Treesitter
vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }
local parsers = {
                "c", "lua","query", "heex", "javascript", "html", "markdown", "markdown_inline", "python", "rust","json", "toml", "gdscript","godot_resource","gdshader"
            }
require('nvim-treesitter').install(parsers)
local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end})


require('snacks').setup({
    image = {enable = true},
    picker = {},
    explorer = {},
    indent = {},
    lazygit = {},
    terminal = {}
})
require("oil").setup()
require("nvim-autopairs").setup{}

--options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Amount to indent with << and >>
vim.opt.tabstop = 4 -- How many spaces are shown per Tab
vim.opt.softtabstop = 4 -- How many spaces are applied when pressing Tab

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- Keep identation from previous line

-- Enable break indent
vim.opt.breakindent = true

-- Always show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show line under cursor
vim.opt.cursorline = true

-- Store undos between sessions
vim.opt.undofile = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.o.winborder = "rounded"
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.so = 10

vim.opt.backup = false                             -- Don't create backup files
vim.opt.writebackup = false                        -- Don't create backup before writing
vim.opt.swapfile = false
vim.opt.autoread = true                            -- Auto reload files changed outside vim
vim.opt.autowrite = false

--KEYMAPS
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", {desc="Open Parent Directory in Oil"})
vim.keymap.set("n", "<leader>o-", "<cmd>Oil<CR>", {desc="Open Parent Directory in Oil"})
vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n><C-w>h',{silent = true}, { desc = 'Exit terminal mode' })
vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>", {desc="Neogit"})
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
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, {desc = "Grep"})
vim.keymap.set("n", "<leader>pp", function() Snacks.picker.projects() end, {desc = "Projects"})
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, {desc = "Recent"})
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, {desc = "Grep Open Buffers"})
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.git_files() end, {desc = "git grep"})
vim.keymap.set("n", "<leader>fd", function() Snacks.picker.diagnostics() end, {desc = "Diagnostics" })
-- LSP
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, {desc = "Goto Definition"})
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, {desc = "Goto Declaration"})
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, {desc = "References"})
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, {desc = "Goto Implementation"})
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, {desc = "Goto T[y]pe Definition"})
vim.keymap.set("n", "sd", vim.diagnostic.open_float,{desc = "Open floating diagnostics window"} )
vim.keymap.set("n","<leader>cr", vim.lsp.buf.rename, {desc ='[R]e[n]ame'})
--  other snack bindings
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.man() end, {desc = "man pages"})
-- Terminal
vim.keymap.set("n","<F12>", function() Snacks.terminal.toggle() end, {desc = "toggle terminal"})

-- move line or selection
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- make j and k move by visual line when softwrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
--yank and paste from system clipboard
vim.keymap.set('n', '<leader>p', '"+p')  -- paste after cursor
vim.keymap.set('n', '<leader>P', '"+P')  -- paste before cursor
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y') -- yank motion
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y') -- yank line
vim.keymap.set({'n'},'<leader>up', function() vim.pack.update(nil, {force=true}) end, {desc="update packages"})
