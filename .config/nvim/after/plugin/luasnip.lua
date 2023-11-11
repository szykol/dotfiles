local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

require("luasnip.loaders.from_vscode").lazy_load()
ls.config.setup {}

ls.add_snippets("go", {
  s("eri", {
    t({ "if err != nil {", "" }),
    t("\t"),
    i(1),
    t({ "", "}" }),
  }),
})

ls.add_snippets("go", {
  s("test", {
    t({ "func Test(t *testing.T) {", "" }),
    t("\t"),
    i(1),
    t({ "", "}" }),
  }),
})
