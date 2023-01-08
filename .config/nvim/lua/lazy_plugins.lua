return {
  "folke/which-key.nvim",

  {
    'lalitmee/cobalt2.nvim',
    dependencies = { 'tjdevries/colorbuddy.nvim' },
    config = function ()
      require"colorbuddy".colorscheme('cobalt2')
      require"hlargs".setup()
    end
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    lazy = true,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = {
      current_line_blame = true
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "cpp", "bash", "python", "typescript", "javascript", "go" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },

  { "szw/vim-maximizer", lazy = true },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'kyazdani42/nvim-web-devicons'},
    config = {
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
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  'onsails/lspkind-nvim',
  'ray-x/lsp_signature.nvim',

  {
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = true
  },

  'L3MON4D3/LuaSnip',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-calc',
  'f3fora/cmp-spell',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp-signature-help',

  'p00f/clangd_extensions.nvim',
  'mfussenegger/nvim-dap',

  {
    'rcarriga/nvim-dap-ui',
    config = true,
    -- config = function()
    --   require"dapui".setup()
    -- end
  },

  {
    'mfussenegger/nvim-dap-python',
    config = function()
      local dap_python = require"dap-python"
      dap_python.setup('~/.virtualenvs/debugpy/bin/python')
      dap_python.test_runner = "pytest"
    end
  },

  {
    'leoluz/nvim-dap-go',
    -- config = function()
    --   require"dap-go".setup()
    -- end
    config = true,
  },

  -- {
  --   'nvim-neotest/neotest',
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-neotest/neotest-go",
  --     "nvim-neotest/neotest-python",
  --   },
  --   config = {
  --     adapters = {
  --       require('neotest-go'),
  --       require('neotest-python')({
  --         runner = "pytest"
  --       })
  --     }
  --   }
  -- },
  --
  -- {
  --   "ThePrimeagen/refactoring.nvim",
  --   dependencies = {
  --       {"nvim-lua/plenary.nvim"},
  --       {"nvim-treesitter/nvim-treesitter"}
  --   },
  --   config = function()
  --     require"telescope".load_extension("refactoring")
  --   end
  -- },

  'jubnzv/virtual-types.nvim',
  'Mofiqul/trld.nvim',


  -- {
  --   'rmagatti/auto-session',
  --   config = {
  --     log_level = 'info',
  --     auto_session_suppress_dirs = {'~/', '~/Projects'}
  --   },
  -- },

  {
    'ray-x/go.nvim',
    config = true,
  },

  {
    'numToStr/Comment.nvim',
    config = true,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
  },

  'm-demare/hlargs.nvim',

  {
    "glepnir/lspsaga.nvim",
    config = function()
      local saga = require("lspsaga")
      saga.init_lsp_saga{}
    end,
  },

  -- {
  --   "ThePrimeagen/git-worktree.nvim",
  --   dependencies = {
  --       "nvim-lua/plenary.nvim",
  --       "nvim-telescope/telescope.nvim",
  --   },
  --   config = function()
  --     require"telescope".load_extension("git_worktree")
  --   end
  -- }
  --
  'tpope/vim-fugitive',

  "williamboman/mason-lspconfig.nvim",
  "williamboman/mason.nvim",
  'neovim/nvim-lspconfig',

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        debounce = 150,
        save_after_format = false,
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.black,
          nls.builtins.diagnostics.flake8,
          nls.builtins.formatting.gofumpt,
          nls.builtins.diagnostics.golangci_lint,
        },
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git", "go.sum"),
      })
    end,
  },
}
