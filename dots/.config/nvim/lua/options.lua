local options = {
  is_transparent = false
}

-- [Basic Options]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.mapleader = " "         
vim.opt.clipboard = "unnamedplus"

-- [OSC52 Clipboard Provider for SSH/Zellij]
local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end
local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end
vim.g.clipboard = {
  name = 'osc52',
  copy = {
    ['+'] = copy,
    ['*'] = copy,
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}

vim.opt.termguicolors = true
vim.opt.laststatus = 3        -- Global Statusline
vim.opt.cmdheight = 1         -- Command line height
vim.opt.conceallevel = 2      -- Conceallevel 2 for markview markdown UI
vim.opt.signcolumn = "yes"    -- Always show signcolumn for smooth cursor & git signs

-- [YAML Settings for DevOps]
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"yaml", "yml"},
  callback = function()
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.number = true
  end,
})

return options
