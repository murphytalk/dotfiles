local default_clr='solarized-osaka'
function ColorMyPencils(color)
    color = color or default_clr
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0,"Normal",{bg = "none"})
    vim.api.nvim_set_hl(0,"NormalFloat",{bg = "none"})
end

ColorMyPencils(default_clr)
