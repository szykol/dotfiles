-- Based on https://github.com/glepnir/galaxyline.nvim/blob/main/example/eviline.lua
local gl = require('galaxyline')
local colors = require('galaxyline.theme').default

-- colors.light_bg = "#353b46"
colors.light_bg = "#2c343c"

colors.bg = "#282c34"

local condition = require('galaxyline.condition')
local gls = gl.section
local fileinfo = require('galaxyline.provider_fileinfo')
local vcs = require('galaxyline.provider_vcs')
local diagnostic = require('galaxyline.provider_diagnostic')

local icons = require('nvim-web-devicons')

local git_icon, _ = icons.get_icon("git")
local git_icon_color = "#F1502F"

local system_icons = {
  unix = '', -- e712
  dos = '', -- e70f
  mac = '', -- e711
}

local circle_sep_right = ' '
local circle_sep_left = ''

gl.short_line_list = {
    'LuaTree',
    'dbui',
    'startify',
    'term',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug'
}

local lsp_condition = function ()
  local tbl = {['dashboard'] = true,['']=true}
  if tbl[vim.bo.filetype] then
    return false
  end
  return true
end

local trim_spaces = function (s)
    if s then
        return string.gsub(s, "%s+", "")
    end
    return s
end

local trim_last_space = function (s)
    if s then
        return string.sub(s, 1, -2)
    end
    return s
end

gls.left = {}

table.insert(gls.left, {
  RainbowBlue = {
    provider = function() return '▊  ' end,
    highlight = {colors.blue,colors.bg},
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
  },
})

table.insert(gls.left, {
  SectionStart = {
    provider = function() return circle_sep_left end,
    highlight = {colors.light_bg,colors.bg},
    separator_highlight = {'NONE',colors.light_bg},
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
      local alias = {n = 'N',i = 'I',c= 'C',v= 'V',V= 'VL', [''] = 'VB'}
      return alias[vim.fn.mode()]
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.light_bg},
    highlight = {colors.red,colors.light_bg,'bold'},
  },
})

table.insert(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.light_bg},
  },
})

table.insert(gls.left, {
  FileName = {
    provider = function() return trim_last_space(fileinfo.get_current_file_name()) end,
    condition = condition.buffer_not_empty,
    highlight = {colors.blue,colors.light_bg,'bold'}
  }
})

table.insert(gls.left, {
  SectionEnd = {
    provider = function() return circle_sep_right end,
    highlight = {colors.light_bg,colors.bg},
    separator_highlight = {'NONE',colors.bg},
  },
})

table.insert(gls.left, {
  SectionStart = {
    provider = function() return circle_sep_left end,
    condition = condition.check_git_workspace,
    highlight = {colors.light_bg,colors.bg},
    separator_highlight = {'NONE',colors.bg},
  },
})

table.insert(gls.left, {
  GitIcon = {
    provider = function() return git_icon end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.light_bg},
    highlight = {git_icon_color,colors.light_bg,'bold'},
  }
})

table.insert(gls.left, {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {git_icon_color,colors.light_bg,'bold'},
  }
})

table.insert(gls.left, {
  DiffAdd = {
    provider = function()
        return trim_spaces(vcs.diff_add())
    end,
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = '  +',
    highlight = {colors.green,colors.light_bg},
  }
})

table.insert(gls.left, {
  DiffModified = {
    provider = function()
        return trim_spaces(vcs.diff_modified())
    end,
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = '  ~',
    highlight = {colors.yellow,colors.light_bg},
  }
})

table.insert(gls.left, {
  DiffRemove = {
    provider = function()
        return trim_spaces(vcs.diff_remove())
    end,
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = '  -',
    highlight = {colors.red,colors.light_bg},
  }
})

table.insert(gls.left, {
  SectionEnd = {
    provider = function() return circle_sep_right end,
    highlight = {colors.light_bg,colors.bg},
    condition = condition.check_git_workspace,
  },
})

table.insert(gls.left, {
  SectionStart = {
    provider = function() return circle_sep_left end,
    highlight = {colors.light_bg,colors.bg},
    separator_highlight = {'NONE',colors.bg},
  },
})

table.insert(gls.left, {
  ShowLspClient = {
    provider = 'GetLspClient',
    condition = lsp_condition,
    icon = '  ',
    highlight = {colors.green,colors.light_bg,'bold'},
    separator = ' ',
    separator_highlight = {'NONE',colors.light_bg},
  }
})

table.insert(gls.left, {
  DiagnosticError = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_error())
    end,
    icon = ' ',
    highlight = {colors.red,colors.light_bg},
    separator_highlight = {'NONE',colors.light_bg},
  }
})

table.insert(gls.left, {
  DiagnosticWarn = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_warn())
    end,
    icon = ' ',
    highlight = {colors.yellow,colors.light_bg},
    separator_highlight = {'NONE',colors.light_bg},
  }
})

table.insert(gls.left, {
  DiagnosticHint = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_hint())
    end,
    icon = ' ',
    highlight = {colors.cyan,colors.light_bg},
    separator_highlight = {'NONE',colors.light_bg},
  }
})

table.insert(gls.left, {
  DiagnosticInfo = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_info())
    end,
    icon = ' ',
    highlight = {colors.blue,colors.light_bg},
    separator_highlight = {'NONE',colors.light_bg},
  }
})

table.insert(gls.left, {
  SectionEnd = {
    provider = function() return circle_sep_right end,
    highlight = {colors.light_bg,colors.bg},
  },
})

gls.right = {}

table.insert(gls.right, {
  SectionStart = {
    provider = function() return circle_sep_left end,
    highlight = {colors.light_bg,colors.bg},
  },
})

table.insert(gls.right, {
  FileSize = {
    provider = 'FileSize',
    condition = condition.hide_in_width,
    highlight = {colors.blue,colors.light_bg,'bold'}
  }
})

table.insert(gls.right, {
  FileEncode = {
    provider = function ()
        return string.lower(fileinfo.get_file_encode())
    end,
    condition = condition.hide_in_width,
    highlight = {colors.fg,colors.light_bg,'bold'}
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
    separator_highlight = {'NONE',colors.light_bg},
    highlight = {colors.blue,colors.light_bg,'bold'}
  }
})

table.insert(gls.right, {
  LineInfo = {
    provider = function ()
      return trim_spaces(fileinfo.line_column())
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.light_bg},
    highlight = {colors.fg,colors.light_bg},
  },
})

table.insert(gls.right, {
  PerCent = {
    provider = function()
        return trim_spaces(fileinfo.current_line_percent())
    end,
    highlight = {colors.fg,colors.light_bg,'bold'},
  }
})

table.insert(gls.right, {
  SectionEnd = {
    provider = function() return circle_sep_right end,
    highlight = {colors.light_bg,colors.bg},
  },
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
