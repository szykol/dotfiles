vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'tweekmonster/startuptime.vim'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require"gitsigns".setup({
        current_line_blame = true
      })
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "cpp", "bash", "python", "typescript", "javascript", "go" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }
  use 'szw/vim-maximizer'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require"lualine".setup {
        options = {
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = { function() return vim.fn.expand("%F") end},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            function()
              return vim.fn.expand("%F")
            end
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_winbar = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            function()
              return vim.fn.expand("%F")
            end
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        }
      }
    end
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require"telescope".setup{}
    end
  }
  use 'onsails/lspkind-nvim'
  use 'ray-x/lsp_signature.nvim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    tag = 'nightly',
    config = function()
      require"nvim-tree".setup {}
    end
  }
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'saadparwaiz1/cmp_luasnip'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-calc'
  use 'f3fora/cmp-spell'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'

  use 'p00f/clangd_extensions.nvim'
  use 'mfussenegger/nvim-dap'
  use {
    'rcarriga/nvim-dap-ui',
    config = function()
      require"dapui".setup()
    end
  }
  use {
    'mfussenegger/nvim-dap-python',
    config = function()
      local dap_python = require"dap-python"
      dap_python.setup('~/.virtualenvs/debugpy/bin/python')
      dap_python.test_runner = "pytest"
    end
  }
  use {
    'leoluz/nvim-dap-go',
    config = function()
      require"dap-go".setup()
    end
  }
  use({
    'nvim-neotest/neotest',
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-go'),
          require('neotest-python')({
            runner = "pytest"
          })
        }
      })
    end
  })
  use 'jubnzv/virtual-types.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
    },
    config = function()
      require"telescope".load_extension("refactoring")
    end
  }
  use 'Mofiqul/trld.nvim'
  use {
    "FeiyouG/command_center.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require"telescope".load_extension("command_center")
    end
  }
  use { 'lalitmee/cobalt2.nvim', requires = 'tjdevries/colorbuddy.nvim' }
  use {
    "catppuccin/nvim", as = "catppuccin",
  }
  use {
    'rmagatti/auto-session',
    config = function()
      require"auto-session".setup {
        log_level = 'info',
        auto_session_suppress_dirs = {'~/', '~/Projects'}
      }
    end
  }
  use {
    'ray-x/go.nvim',
    config = function()
      require('go').setup()
    end
  }
  use 'lewis6991/impatient.nvim'
  use {
    'numToStr/Comment.nvim',
    config = function()
      require"Comment".setup()
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require'treesitter-context'.setup{}
    end
  }
  use 'm-demare/hlargs.nvim'
  use {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      local saga = require("lspsaga")
      saga.init_lsp_saga{}
    end,
  }

  use "rafamadriz/friendly-snippets"
  use {
    "doums/suit.nvim",
    config = function()
      require"suit".setup{}
    end
  }
  -- use "sam4llis/nvim-tundra"
  use {
    "ThePrimeagen/git-worktree.nvim",
    requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-telescope/telescope.nvim"}
    },
    config = function()
      require"telescope".load_extension("git_worktree")
    end
  }
  use 'tpope/vim-fugitive'
end)
