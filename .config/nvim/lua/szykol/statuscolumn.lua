-- inspired by https://www.reddit.com/r/neovim/comments/10bmy9w/comment/j4brqx3/
-- and https://www.reddit.com/r/neovim/comments/10fpqbp/gist_statuscolumn_separate_diagnostics_and/

local M = {}

local git_gutter_sign = "┃"
local default_highlight = "%#LineNr#"
local inactive_git_highlight = "%#NonText#"
local gitsigns_untracked = "GitSignsUntracked"

M.diagnostic_sign_from_hl = {
  DiagnosticSignError = " ",
  DiagnosticSignWarn = " ",
  DiagnosticSignInfo = " ",
  DiagnosticSignHint = " ",
}

M.get_signs_for_current_line = function ()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.v.lnum
  local signs = vim.fn.sign_getplaced(bufnr, {group="*", lnum=lnum})
  signs = signs[1]
  return signs.signs
end

M.find_sign_name_from_hl = function(signs, hl_name)
  if signs == nil then
    return nil
  end
  for _, sign_table in ipairs(signs) do
    if sign_table.name:find(hl_name) then
      return sign_table.name
    end
  end
  return nil
end

M.build_hl_name = function (name)
  if name ~= nil and name ~= "" then
    return "%#" .. name .. "#"
  end
  return nil
end

M.create_statuscolumn = function ()
  local signs = M.get_signs_for_current_line()
  local line_number = '%=%{v:relnum?v:relnum:v:lnum} '

  local diag_name = M.find_sign_name_from_hl(signs, "^Diagnostic") or ""
  local diag_hl_name = M.build_hl_name(diag_name)
  local diag_sign = M.diagnostic_sign_from_hl[diag_name] or ""

  local git_name = M.find_sign_name_from_hl(signs, "^GitSigns") or ""
  local git_hl_name
  if git_name == gitsigns_untracked then
    git_hl_name = inactive_git_highlight
  else
    git_hl_name = M.build_hl_name(git_name)
  end

  local stl = table.concat({
    " ",
    diag_hl_name or "",
    diag_sign,
    default_highlight,
    line_number,
    git_hl_name or inactive_git_highlight,
    git_gutter_sign,
    " ",
  }, "")
  return stl
end

M.set_statuscolumn = function ()
  vim.opt.statuscolumn = M.create_statuscolumn()
end

_G.SZYKOL_STC = function ()
  return M.create_statuscolumn()
end

M.set_global_statuscolumn = function ()
  local stl = [[%!v:lua.SZYKOL_STC()]]
  vim.opt.statuscolumn = stl
end

return M
