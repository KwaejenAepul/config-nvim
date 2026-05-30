require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter",{callback=function()require"lazy".update({show = false})end})
vim.o.background = "dark"
vim.cmd[[colorscheme tokyonight-night]]
local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end

