require("config.lazy")
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
if gdproject then
    io.close(gdproject)
    vim.fn.serverstart './godothost'
end
