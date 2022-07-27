vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'tweekmonster/startuptime.vim'
  use 'lewis6991/gitsigns.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'szw/vim-maximizer'
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'onsails/lspkind-nvim'
  use 'ray-x/lsp_signature.nvim'
  use 'kyazdani42/nvim-tree.lua'

  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-calc'
  use 'f3fora/cmp-spell'
  use 'hrsh7th/cmp-cmdline'

  use 'p00f/clangd_extensions.nvim'
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'mfussenegger/nvim-dap-python'
  use 'antoinemadec/FixCursorHold.nvim'
  use 'nvim-neotest/neotest'

  use 'rafcamlet/tabline-framework.nvim'
  use 'jubnzv/virtual-types.nvim'
  use 'tami5/lspsaga.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'ThePrimeagen/refactoring.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'Mofiqul/trld.nvim'
  use 'gfeiyou/command-center.nvim'

  use 'tjdevries/colorbuddy.nvim'
  use 'lalitmee/cobalt2.nvim'
  use 'rmagatti/auto-session'
  use 'ray-x/go.nvim'

end)
