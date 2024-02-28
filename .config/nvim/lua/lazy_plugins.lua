return {
  {
  	"folke/which-key.nvim",
  	event = "VeryLazy",
  	init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
  	end,
  	opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
  	}
  },

  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   config = function ()
  --     vim.opt.background = "dark"
  --     vim.cmd.colorscheme "tokyonight"
  --   end
  -- },
--   {
--   'roobert/palette.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd("colorscheme palette")
--   end
-- },
--
  -- {
  --   "EdenEast/nightfox.nvim",
  --   priority = 1000,
  --   config = function ()
  --     vim.cmd.colorscheme "nightfox"
  --   end
  -- },

  -- {
  --   "f-person/auto-dark-mode.nvim",
  --   config = {
  --     update_interval = 1000,
  --     set_dark_mode = function()
  --       vim.opt.background = "dark"
  --       vim.cmd.colorscheme 'nightfox'
  --     end,
  --     set_light_mode = function()
  --       vim.opt.background = "light"
  --       vim.cmd.colorscheme 'nightfox'
  --     end,
  --   },
  -- },

  {
    'catppuccin/nvim',
    priority = 1000,
    config = function ()
      vim.opt.background = "light"
      vim.cmd.colorscheme "catppuccin"
    end
  },


  -- {
  --   "navarasu/onedark.nvim",
  --   priority = 1000,
  --   config = function ()
  --     require"onedark".setup{
  --       style = "deep",
  --       highlights = {
  --         ["NormalFloat"] = {
  --           bg="#1a212e",
  --         },
  --         ["FloatBorder"] = {
  --           fg="#93a4c3",
  --           bg="#1a212e",
  --         },
  --       },
  --     }
  --     vim.cmd.colorscheme "onedark"
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
      current_line_blame = true,
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
      },
    },
    event = "VeryLazy",
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { "szw/vim-maximizer", lazy = true, cmd = "MaximizerToggle" },

  {
    "stevearc/aerial.nvim",
    config = function ()
      require "aerial".setup()
      require "telescope".load_extension('aerial')
    end,
    event = "VeryLazy",
  },

  {
    'nvim-telescope/telescope.nvim',
    opts = {
      extensions = {
          ["ui-select"] = {
            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
             specific_opts = {
               -- for example to disable the custom builtin "codeactions" display do the following
               codeactions = false,
             }
          }
        }
    },
    event = "VeryLazy",
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    }
  },

  'onsails/lspkind-nvim',

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  'L3MON4D3/LuaSnip',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',
  'f3fora/cmp-spell',
  'hrsh7th/cmp-cmdline',

  {
    'p00f/clangd_extensions.nvim',
    ft = { "cpp", "c" },
  },

  {
    'mfussenegger/nvim-dap',
    lazy = true,
  },

  {
    'rcarriga/nvim-dap-ui',
    config = true,
    event = "VeryLazy",
  },

  {
    'mfussenegger/nvim-dap-python',
    ft = "python",
    config = function()
      local dap_python = require"dap-python"
      dap_python.setup('~/.virtualenvs/debugpy/bin/python')
      dap_python.test_runner = "pytest"

      local configurations = require"dap".configurations.python
      for _, configuration in pairs(configurations) do
        configuration.justMyCode = false
      end
    end,
  },

  {
    'leoluz/nvim-dap-go',
    config = true,
    ft = "go",
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
            python = function () return vim.fn.getcwd() .. "/.venv/bin/python" end,
          }),
          require('rustaceanvim.neotest'),
        }
      })
    end,
    lazy = true,
  },

  -- 'jubnzv/virtual-types.nvim',
  -- 'Mofiqul/trld.nvim',

  {
    'ray-x/go.nvim',
    opts = {
      lsp_inlay_hints = {
        enable = false,
      },
      diagnostic = false,
    },
    ft = "go",
  },

  {
    'numToStr/Comment.nvim',
    config = true,
  },

  {
    'm-demare/hlargs.nvim',
    config = true,
  },

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
    dependencies = { {"nvim-tree/nvim-web-devicons"} },
    lazy = true,
  },

  {
    'tpope/vim-fugitive',
    lazy = true,
    event = "VeryLazy",
  },

  -- Detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      'folke/neodev.nvim',
    },
  },

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
          -- nls.builtins.diagnostics.ruff,
          -- nls.builtins.formatting.gofumpt,
          -- nls.builtins.diagnostics.golangci_lint,
        },
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git", "go.sum"),
      })
    end,
  },

  {
    'mhinz/vim-rfc',
    cmd = "RFC",
    lazy = true,
  },

  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
  },

  -- {
  --   "luukvbaal/statuscol.nvim",
  --   config = function ()
  --     require"statuscol".setup()
  --   end
  -- },

  {
    "theHamsta/nvim-dap-virtual-text",
    branch = "inline-text",
    config = function()
      require"nvim-dap-virtual-text".setup()
    end,
    event = "VeryLazy",
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
    ft = "norg",
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

  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
  },

  {
    "junegunn/vim-easy-align",
  },
  {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = function ()
        require("telescope").load_extension "file_browser"
      end,
      event = "VeryLazy",
  },

  {
      "nvim-telescope/telescope-ui-select.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = function ()
        require("telescope").load_extension "ui-select"
      end,
      event = "VeryLazy",
  },

  -- "szykol/statusline.nvim",
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'kyazdani42/nvim-web-devicons'},
  },
  -- {'neoclide/coc.nvim', branch = 'release'},
  -- {
  --   'altermo/ultimate-autopair.nvim',
  --   event = {'InsertEnter','CmdlineEnter'},
  --   branch = 'v0.6',
  --   opts = {
  --       --Config goes here
  --   },
  -- },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function ()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        }
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
      }
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
  },
}
