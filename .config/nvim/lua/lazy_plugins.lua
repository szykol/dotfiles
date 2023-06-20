return {
  "folke/which-key.nvim",

  -- {
  --   'lalitmee/cobalt2.nvim',
  --   dependencies = { 'tjdevries/colorbuddy.nvim' },
  --   priority = 1000,
  --   config = function ()
  --     require"colorbuddy".colorscheme('cobalt2')
  --     require"hlargs".setup()
  --   end
  -- },

  -- {
  --   'Yagua/nebulous.nvim',
  --   dependencies = { 'tjdevries/colorbuddy.nvim' },
  --   priority = 1000,
  --   config = function ()
  --     require"colorbuddy".colorscheme('nebulous')
  --     require("nebulous.functions").set_variant("twilight")
  --     require"hlargs".setup()
  --   end
  -- },

  -- {
  --   "catppuccin/nvim",
  --   priority = 1000,
  --   config = function ()
  --     require"catppuccin".setup {
  --       -- styles = {
  --       --   comments = { "italic" },
  --       --   conditionals = { "italic" },
  --       --   loops = { "italic", "bold" },
  --       --   functions = { "bold" },
  --       --   keywords = { "italic", "bold" },
  --       --   strings = { "italic" },
  --       --   variables = {},
  --       --   numbers = {},
  --       --   booleans = { "italic" },
  --       --   properties = { "bold" },
  --       --   types = { "bold" },
  --       --   operators = { "bold" },
  --       -- },
  --     }
  --     vim.cmd.colorscheme "catppuccin"
  --   end
  -- },

  -- {
  --   "Shatur/neovim-ayu",
  --   priority = 1000,
  --   config = function ()
  --     require('ayu').colorscheme()
  --   end
  -- },

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function ()
      vim.opt.background = "dark"
      vim.cmd.colorscheme "tokyonight"
    end
  },

  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000,
  --   config = function ()
  --     vim.opt.background = "light"
  --     vim.cmd.colorscheme "onelight"
  --   end
  -- },

  -- {
  --   "NTBBloodbath/sweetie.nvim",
  --   priority = 1000,
  --   config = function ()
  --     vim.opt.background = "light"
  --     vim.cmd.colorscheme "sweetie"
  --   end
  -- },

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
        ensure_installed = { "cpp", "bash", "python", "typescript", "javascript", "go", "markdown", "markdown_inline" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },

  { "szw/vim-maximizer", lazy = true, cmd = "MaximizerToggle" },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'kyazdani42/nvim-web-devicons'},
    config = {
        options = {
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {
              "dap-repl",
            }
          }
        },
        winbar = {
          lualine_c = { function() return require"lspsaga.symbolwinbar":get_winbar() or "" end },
          lualine_x = { "filename" },
        },
        inactive_winbar = {
          lualine_c = { "aerial" },
          lualine_x = { "filename" },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = { function() return vim.fn.expand("%F") end},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'},
        },
        extensions = { "nvim-dap-ui" },
    }
  },

  {
    "stevearc/aerial.nvim",
    config = function ()
      require "aerial".setup()
      require "telescope".load_extension('aerial')
    end
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  'onsails/lspkind-nvim',
  'ray-x/lsp_signature.nvim',

  {
    'nvim-tree/nvim-tree.lua',
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

  {
    'mfussenegger/nvim-dap',
  },

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

      local configurations = require"dap".configurations.python
      for _, configuration in pairs(configurations) do
        configuration.justMyCode = false
      end
    end
  },

  {
    'leoluz/nvim-dap-go',
    -- config = function()
    --   require"dap-go".setup()
    -- end
    config = true,
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,

        }}, neotest_ns)
      require"neotest".setup({
        adapters = {
          require('neotest-go'),
          require('neotest-python')({
            runner = "pytest",
            dap = { justMyCode = false },
          })
        }
      })
    end
  },
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
    event = "BufRead",
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = false,
          color_mode = false,
        }
      })
    end,
    dependencies = { {"kyazdani42/nvim-web-devicons"} }
  },

  -- 'tpope/vim-fugitive',

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
          -- nls.builtins.formatting.isort,
          -- nls.builtins.formatting.black,
          -- nls.builtins.diagnostics.flake8,
          nls.builtins.diagnostics.ruff,
          nls.builtins.formatting.gofumpt,
          nls.builtins.diagnostics.golangci_lint,
        },
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git", "go.sum"),
      })
    end,
  },

  {
    'mhinz/vim-rfc',
    cmd = "RFC",
  },

  {
    "sindrets/diffview.nvim",
  },

  {
    "luukvbaal/statuscol.nvim", config = function ()
      require"statuscol".setup()
    end
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    branch = "inline-text",
    config = function()
      require"nvim-dap-virtual-text".setup()
    end
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end
  },

  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
              },
            },
          },
        },
      }
    end,
  },

}
