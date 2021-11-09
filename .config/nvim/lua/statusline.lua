-- Based on https://github.com/glepnir/galaxyline.nvim/blob/main/example/eviline.lua
local gl = require('galaxyline')
local colors = require('galaxyline.theme').default
colors.bg = "#2c343c"

local condition = require('galaxyline.condition')
local gls = gl.section
local fileinfo = require('galaxyline.provider_fileinfo')
local icons = require('nvim-web-devicons')

local git_icon, _ = icons.get_icon("git")
local git_icon_color = "#F1502F"

local system_icons = {
  unix = '', -- e712
  dos = '', -- e70f
  mac = '', -- e711
}

gl.short_line_list = {'NvimTree','vista','dbui','packer'}

local create_separator = function(text, separator_condition)
    local separator_section = {
        separator = {
            provider = function ()
                return text
            end,
            highlight = {'NONE',colors.bg,},
        }
    }
    if separator_condition then
        separator_section.separator.condition = separator_condition
    end

    return separator_section
end

local lsp_condition = function ()
  local tbl = {['dashboard'] = true,['']=true}
  if tbl[vim.bo.filetype] then
    return false
  end
  return true
end

gls.left = {}

table.insert(gls.left, {
  RainbowRed = {
    provider = function() return '▊ ' end,
    highlight = {colors.blue,colors.bg}
  },
})

table.insert(gls.left, {
  ViMode = {
    provider = function()
      local mode_color = {n = colors.green, i = colors.blue,v=colors.magenta,
                          [''] = colors.magenta,V=colors.magenta,
                          c = colors.orange,no = colors.red,s = colors.orange,
                          S=colors.orange,[''] = colors.orange,
                          ic = colors.yellow,R = colors.violet,Rv = colors.violet,
                          cv = colors.red,ce=colors.red, r = colors.cyan,
                          rm = colors.cyan, ['r?'] = colors.cyan,
                          ['!']  = colors.red,t = colors.red}
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      local alias = {n = 'NORMAL',i = 'INSERT',c= 'COMMAND',v= 'VISUAL',V= 'V-LINE', [''] = 'V-BLOCK'}
      return alias[vim.fn.mode()]
    end,
    separator = '  ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.red,colors.bg,'bold'},
  },
})

table.insert(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
  },
})

table.insert(gls.left, {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.blue,colors.bg,'bold'}
  }
})

table.insert(gls.left, create_separator('  ', nil))

table.insert(gls.left, {
  GitIcon = {
    provider = function() return git_icon end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {git_icon_color,colors.bg,'bold'},
  }
})

table.insert(gls.left, {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {git_icon_color,colors.bg,'bold'},
    separator = '  ',
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = '+',
    highlight = {colors.green,colors.bg},
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiffModified = {
    provider = 'DiffModified',
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = '~',
    highlight = {colors.yellow,colors.bg},
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = '-',
    highlight = {colors.red,colors.bg},
    separator_highlight = {'NONE',colors.bg},
  }
})

local width_and_git_condtition = function ()
    return condition.hide_in_width() and condition.check_git_workspace()
end

table.insert(gls.left, create_separator(' ', width_and_git_condtition))

table.insert(gls.left, {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = lsp_condition,
    icon = '  ',
    separator = ' ',
    highlight = {colors.green,colors.bg,'bold'},
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = ' ',
    highlight = {colors.red,colors.bg},
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = ' ',
    highlight = {colors.yellow,colors.bg},
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = ' ',
    highlight = {colors.cyan,colors.bg},
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
  }
})

table.insert(gls.left, {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = ' ',
    highlight = {colors.blue,colors.bg},
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
  }
})

gls.right = {}

table.insert(gls.right, {
  FileEncode = {
    provider = function ()
        return string.lower(fileinfo.get_file_encode())
    end,
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg,'bold'}
  }
})

table.insert(gls.right, {
  FileFormat = {
    provider = function ()
        local file_format = vim.bo.fileformat
        return system_icons[file_format] or file_format
    end,
    condition = condition.hide_in_width,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
})

table.insert(gls.right, {
  LineInfo = {
    provider = function ()
      local ln_col = fileinfo.line_column()
      ln_col = ln_col:gsub("%s+", "")
      return ln_col .. ' '
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
})

table.insert(gls.right, {
  PerCent = {
    provider = 'LinePercent',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg,'bold'},
  }
})

table.insert(gls.right, {
  RainbowBlue = {
    provider = function() return ' ▊' end,
    highlight = {colors.blue,colors.bg}
  },
})

gls.short_line_left = {}

table.insert(gls.short_line_left, {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
})

table.insert(gls.short_line_left, {
  SFileName = {
    provider =  'SFileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.bg,'bold'}
  }
})

gls.short_line_right = {}

table.insert(gls.short_line_right, {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {colors.fg,colors.bg}
  }
})
