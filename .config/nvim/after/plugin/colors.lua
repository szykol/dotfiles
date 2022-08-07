vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
require("catppuccin").setup {
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = { "italic", "bold" },
    functions = { "bold" },
    keywords = { "italic", "bold" },
    strings = { "italic" },
    variables = {},
    numbers = {},
    booleans = { "italic" },
    properties = { "bold" },
    types = { "bold" },
    operators = { "bold" },
  },
}
vim.cmd [[colorscheme catppuccin]]
