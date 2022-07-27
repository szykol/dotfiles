vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("SZYKOL", { clear = true }),
  pattern = "*.tex",
  command = "TexlabBuild"
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("SZYKOL", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank({on_visual = true}) end
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("SZYKOL", { clear = true }),
--   pattern = "*.py",
--   command = "Black"
-- }

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("SZYKOL", { clear = true }),
  pattern = "*",
  callback = function() require"utils".perform_upload() end
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("SZYKOL", { clear = true }),
  pattern = "*go",
  command = "GoFmt"
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SZYKOL", { clear = true }),
  pattern = "*go",
  callback = function()
    vim.cmd("setlocal")
    vim.opt.expandtab = false
    vim.opt.copyindent = true
    vim.opt.preserveindent = true
    vim.opt.softtabstop = 0
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
  end
})
