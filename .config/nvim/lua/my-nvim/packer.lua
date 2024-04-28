--vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
      'nvim-telescope/telescope.nvim', tag = '0.1.6',
      -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
  }

  use ({ 
      "catppuccin/nvim", 
      as = "catppuccin",
      config = function()
          vim.cmd('colorscheme catppuccin')
      end
  })

  use "olimorris/onedarkpro.nvim"
  use ({"craftzdog/solarized-osaka.nvim", as = "solarized-osaka"})
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use('duane9/nvim-rg')
  use('yorickpeterse/nvim-window')

  use {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      requires = {
          -- LSP
          {'neovim/nvim-lspconfig'},
          {'williamboman/mason.nvim'},
          {'williamboman/mason-lspconfig.nvim'},

          -- Autocompletion
          {'hrsh7th/nvim-cmp'},
          {'hrsh7th/cmp-buffer'},
          {'hrsh7th/cmp-path'},
          {'hrsh7th/cmp-nvim-lsp'},
          {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
      }
  }
end)
