-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('utils')
require('options')
require('keymaps')

-- Define plugin specifications for lazy.nvim
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "folke/tokyonight.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim" },
  { "akinsho/bufferline.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },
  { "stevearc/oil.nvim" },
  { "numToStr/Comment.nvim" },
  { "windwp/nvim-autopairs" },
  { "folke/trouble.nvim" },
  { "akinsho/toggleterm.nvim" },
  { "kdheepak/lazygit.nvim" },
  { "ojroques/nvim-osc52" },
  { "gen740/SmoothCursor.nvim" },
  { "OXY2DEV/markview.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "shellRaining/hlchunk.nvim" },
  { "HiPhish/rainbow-delimiters.nvim" },
  { "echasnovski/mini.icons" },
  { "rcarriga/nvim-notify" },
  { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },
  { "NeogitOrg/neogit", dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" } },
  { "sindrets/diffview.nvim" },
  { "akinsho/git-conflict.nvim" },
  { "epwalsh/obsidian.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" } },
  { "neovim/nvim-lspconfig" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

require('plugins')
