require"lualine".setup{
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
    lualine_c = { function() return require"lspsaga.symbol.winbar":get_bar() or "" end },
    lualine_x = { "filename" },
  },
  inactive_winbar = {
    lualine_c = { "aerial" },
    lualine_x = { "filename" },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = { function() return vim.fn.expand("%F") end},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
        color = { fg = "#ff9e64" },
      },
      {
        'progress'
      },
    },
    lualine_z = {'location'},
  },
  extensions = { "nvim-dap-ui" },
}

