require("config.lazy")
vim.o.background = "dark"
vim.cmd([[colorscheme doom-one]])

vim.api.nvim_create_autocmd("VimEnter",{callback=function()require"lazy".update({show = false})end})

local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end
