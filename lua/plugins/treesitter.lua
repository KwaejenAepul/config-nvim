return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
        local configs = require("nvim-treesitter.config")

        configs.setup({
            ensure_installed = {
                "c", "lua","query", "heex", "javascript", "html", "markdown", "markdown_inline", "python", "rust","json", "toml", "gdscript","godot_resource","gdshader"
            },
            auto_install = true,
            sync_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            init = function()
                vim.api.nvim_create_autocmd('FileType',{
                    callback = function()
                    pcall(vim.treesitter.start)
                end,
                })
            end,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Enter>", -- set to `false` to disable one of the mappings
                    node_incremental = "<Enter>",
                    scope_incremental = false,
                    node_decremental = "<Backspace>",
                },
            },
        })
    end
}
