local command_center = require("command_center")
local noremap = {noremap = true}
local silent_noremap = {noremap = true, silent = true}

command_center.add({
  {
    description = "Open config file",
    cmd = "<CMD>e ~/.config/nvim/init.lua<CR>",
  },
  {
    description = "Reload config file",
    cmd = "<CMD>so ~/.config/nvim/init.lua<CR>",
  },
  {
    description = "Search inside current buffer",
    cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
  }, {
    cmd = "<CMD>Telescope find_files<CR>",
    keybindings = { "n", "<leader>f", noremap },
  }, {
    description = "Find hidden files",
    cmd = "<CMD>Telescope find_files hidden=true<CR>",
  }, {
    description = "Show document symbols",
    cmd = "<CMD>Telescope lsp_document_symbols<CR>",
  }, {
    description = "Show function signaure (hover)",
    cmd = "<CMD>lua vim.lsp.buf.hover()<CR>",
  }, {
    description = "Perform upload",
    cmd = function() require('utils').perform_upload() end,
  }
})
