local function open_terminal()
  vim.cmd("bot sp")
  vim.cmd("resize 15")
  vim.cmd("term")
end

return {
  open_terminal = open_terminal
}
