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

-- highlight function arguments, call after setting colorscheme to make sure nothing is overriden
require"hlargs".setup()
-- require"trld".setup{position = "top"}
