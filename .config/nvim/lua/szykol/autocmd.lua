local group = vim.api.nvim_create_augroup("SZYKOL", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = "*.tex",
  command = "TexlabBuild"
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  pattern = "*",
  callback = function() vim.highlight.on_yank({on_visual = true}) end
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = group,
--   pattern = "*go",
--   command = "GoFmt"
-- })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "*go",
  callback = function()
    vim.opt.expandtab = false
    vim.opt.copyindent = true
    vim.opt.preserveindent = true
    vim.opt.softtabstop = 0
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "*lua",
  callback = function()
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end
})

vim.api.nvim_create_autocmd("InsertLeavePre", {
  callback = function ()
    vim.lsp.inlay_hint(0, true)
  end
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function ()
    vim.lsp.inlay_hint(0, false)
  end
})
