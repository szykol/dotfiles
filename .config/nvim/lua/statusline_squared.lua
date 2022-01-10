-- Based on https://github.com/glepnir/galaxyline.nvim/blob/main/example/eviline.lua
local gl = require('galaxyline')
local colors = require("galaxyline.themes.colors").default

colors.dark_bg = "#353b46"
colors.light_bg = "#2c343c"
-- colors.light_bg = "#282c34"
-- colors.light_bg = "#2c343c"

-- colors.bg = "#282c34"
colors.bg = "#2c343c"

local condition = require('galaxyline.condition')
local gls = gl.section
local fileinfo = require('galaxyline.providers.fileinfo')
local vcs = require('galaxyline.providers.vcs')
local diagnostic = require('galaxyline.providers.diagnostic')
local lspclient = require('galaxyline.providers.lsp')

local get_full_buffer_path = function()
  return vim.fn.expand("%")
end

-- local icons = require('nvim-web-devicons')
-- 
-- local git_icon, _ = icons.get_icon("git")
local git_icon = " "
local git_icon_color = "#F1702F"

local system_icons = {
  unix = ' ', -- e712
  dos = ' ', -- e70f
  mac = ' ', -- e711
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
    'plug',
    'NvimTree',
    'dap',
    'dapui',
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
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

local highlight = function(group, fg, bg, gui)
    local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)

    if gui ~= nil then
        cmd = cmd .. ' gui=' .. gui
    end

    vim.cmd(cmd)
end

colors.black = "#000000"
colors.git_light = "#c9510c"

highlight('StatusLineGitBranch', git_icon_color, colors.light_bg)
highlight('StatusLineGitBranchBg', git_icon_color, colors.bg)
highlight('StatusLineGitBranchEnd', git_icon_color, colors.light_bg)
highlight('StatusLineDefault', colors.fg, colors.light_bg)
highlight('StatusLineGitBranchName', git_icon_color, colors.light_bg, "bold")
highlight('StatusLineGitEnd', colors.light_bg, colors.bg)

highlight('StatusLineGitAdd', colors.green, colors.light_bg)
highlight('StatusLineGitDel', colors.yellow, colors.light_bg)
highlight('StatusLineGitMod', colors.red, colors.light_bg)

highlight('StatusLineLsp', colors.green, colors.light_bg)

highlight('StatusLineLspStart', colors.green, colors.light_bg)
highlight('StatusLineLspIcon', colors.green, colors.light_bg)
highlight('StatusLineLspEnd', colors.light_bg, colors.bg)
highlight('StatusLineLspName', colors.green, colors.light_bg)
highlight('StatusLineLspIconEnd', colors.green, colors.light_bg)

highlight('StatusLineLspDiagErr', colors.red, colors.light_bg)
highlight('StatusLineLspDiagWarn', colors.yellow, colors.light_bg)
highlight('StatusLineLspDiagHint', colors.cyan, colors.light_bg)
highlight('StatusLineLspDiagInfo', colors.blue, colors.light_bg)

highlight('StatusLineBlankLine', colors.blue, colors.light_bg)

gls.left = {}

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
      local alias = {n = '  N',i = '  I',c= '  C',v= '  V',V= '  VL', [''] = '  VB'}
      return alias[vim.fn.mode()]
    end,
    separator = ' ',
    separator_highlight = {'NONE',colors.dark_bg},
    highlight = {colors.red,colors.dark_bg,'bold'},
  },
})

table.insert(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {fileinfo.get_file_icon_color(),colors.dark_bg},
  },
})

table.insert(gls.left, {
  FileName = {
    provider = function() return fileinfo.get_current_file_name('•', nil) end,
    condition = condition.buffer_not_empty,
    highlight = {colors.blue,colors.dark_bg, "bold"}
  }
})

table.insert(gls.left, {
  FileSectionEnd = {
    provider = function() return ' ' end,
    highlight = 'StatusLineGitBranch'
  }
})

table.insert(gls.left, {
  GitIcon = {
    provider = function() return git_icon end,
    condition = condition.check_git_workspace,
    highlight = 'StatusLineGitBranch'
  }
})

table.insert(gls.left, {
  GitBranch = {
    provider = function ()
        return vcs.get_git_branch() .. ' '
    end,
    separator_highlight = {'NONE',colors.light_bg},
    condition = condition.check_git_workspace,
    highlight = 'StatusLineGitBranch'
  }
})

table.insert(gls.left, {
  DiffAdd = {
    provider = function()
        return vcs.diff_add()
    end,
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = ' +',
    highlight = 'StatusLineGitAdd'
  }
})

table.insert(gls.left, {
  DiffModified = {
    provider = function()
        return vcs.diff_modified()
    end,
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = ' ~',
    highlight = 'StatusLineGitMod'
  }
})

table.insert(gls.left, {
  DiffRemove = {
    provider = function()
        return vcs.diff_remove()
    end,
    condition = function ()
        return condition.hide_in_width() and condition.check_git_workspace()
    end,
    icon = ' -',
    highlight = 'StatusLineGitDel'
  }
})

table.insert(gls.left, {
  ShowLspIcon = {
    provider = function()
        return ' '
    end,
    condition = function()
        return lsp_condition() and condition.hide_in_width()
    end,
    highlight = 'StatusLineLspIcon',
  }
})

table.insert(gls.left, {
  ShowLspClient = {
    provider = function()
        return trim_spaces(lspclient.get_lsp_client("none"))
    end,
    condition = function()
        return lsp_condition() and condition.hide_in_width()
    end,
    highlight = 'StatusLineLspName',
  }
})

table.insert(gls.left, {
  DiagnosticError = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_error())
    end,
    icon = '   ',
    highlight = 'StatusLineLspDiagErr',
  }
})

table.insert(gls.left, {
  DiagnosticWarn = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_warn())
    end,
    icon = '   ',
    highlight = 'StatusLineLspDiagWarn',
  }
})

table.insert(gls.left, {
  DiagnosticHint = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_hint())
    end,
    icon = '   ',
    -- icon = '   ',
    highlight = 'StatusLineLspDiagHint',
  }
})

table.insert(gls.left, {
  DiagnosticInfo = {
    provider = function()
        return trim_spaces(diagnostic.get_diagnostic_info())
    end,
    icon = '   ',
    highlight = 'StatusLineLspDiagInfo',
  }
})

table.insert(gls.left, {
  EndLeftLine = {
    provider = function()
        return ' '
    end,
    highlight = 'StatusLineBlankLine',
  }
})

-- table.insert(gls.left, {
--   LspSectionEnd = {
--     provider = function() return circle_sep_right end,
--     highlight = 'StatusLineLspEnd',
--   },
-- })

gls.right = {}

table.insert(gls.right, {
  RightLineStart = {
    provider = function() return ' ' end,
    highlight = {colors.blue,colors.dark_bg}
  }
})

table.insert(gls.right, {
  FileSize = {
    provider = 'FileSize',
    condition = condition.hide_in_width,
    highlight = {colors.blue,colors.dark_bg,'bold'}
  }
})

table.insert(gls.right, {
  FileEncode = {
    provider = function ()
        return string.lower(fileinfo.get_file_encode())
    end,
    condition = condition.hide_in_width,
    highlight = {colors.fg,colors.dark_bg,'bold'}
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
    separator_highlight = {'NONE',colors.dark_bg},
    highlight = {colors.blue,colors.dark_bg,'bold'}
  }
})

table.insert(gls.right, {
  LineInfo = {
    provider = function ()
      return trim_spaces(fileinfo.line_column()) .. ' '
    end,
    highlight = {colors.fg,colors.dark_bg},
  },
})

table.insert(gls.right, {
  PerCent = {
    provider = function()
        return fileinfo.current_line_percent()
    end,
    highlight = {colors.fg,colors.dark_bg,'bold'},
  }
})

gls.short_line_left = {}

table.insert(gls.short_line_left, {
  LeftLineSep = {
    provider = function() return ' ' end,
    highlight = {colors.blue,colors.dark_bg},
  },
})

table.insert(gls.short_line_left, {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE',colors.dark_bg},
    highlight = {colors.fg,colors.dark_bg,'bold'}
  }
})

table.insert(gls.short_line_left, {
  SFileName = {
    provider = function() return trim_spaces(get_full_buffer_path()) end,
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.dark_bg}
  }
})

gls.short_line_right = {}

-- table.insert(gls.short_line_right, {
--   BufferIcon = {
--     provider= 'BufferIcon',
--     highlight = {colors.fg,colors.bg}
--   }
-- })
