local ls = require"luasnip"
local snip_types = require"luasnip.util.types"
local cmp = require'cmp'
local types = require('cmp.types')
local mapping = require('cmp.config.mapping')
local lspkind = require('lspkind')

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "gopls" },
}

ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [snip_types.choiceNode] = {
      active = {
        virt_text = { { "<-", "Error" } },
      },
    },
  },
}

-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })
--
-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })

vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-n>'] = {
        i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
        c = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
      },
      ['<C-p>'] = {
        i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
        c = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
      },
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = {
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'spell' },
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
        ellipsis_char = '...',
        menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })
      })
    },
    experimental = {
      ghost_text = true
    },
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer', keyword_length = 2 }
      }
    }),
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path', keyword_length = 2 }
      }, {
        { name = 'cmdline', keyword_length = 2 }
      })
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  if client.supports_method('textDocument/codeLens') then
    require'virtualtypes'.on_attach(client, bufnr)
  end

  if client.supports_method('textDocument/inlayHint') then
    vim.lsp.buf.inlay_hint(bufnr, true)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.keymap.set('n', 'gd',         '<cmd>Lspsaga goto_definition<CR>', opts)
  vim.keymap.set('n', 'K',          '<cmd>Lspsaga hover_doc<CR>', opts)
  vim.keymap.set('n', 'gi',         '<cmd>Telescope lsp_implementations<CR>', opts)
  -- vim.keymap.set('n', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
  vim.keymap.set('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.keymap.set('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', opts)
  vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
  vim.keymap.set('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.keymap.set('n', '<leader>sd', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
  vim.keymap.set('n', '<leader>sc', '<cmd>Lspsaga show_cursor_diagnostics<CR>', opts)
  vim.keymap.set('n', '<leader>sk', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
  vim.keymap.set('n', '<leader>sj', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
  vim.keymap.set('n', '<leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.keymap.set('n', '<leader>r',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.keymap.set('n', '<leader>iy',  function() vim.lsp.buf.inlay_hint(bufnr, true) end, opts)
  vim.keymap.set('n', '<leader>in',  function() vim.lsp.buf.inlay_hint(bufnr, false) end, opts)
end

local servers = { 'pyright', 'vimls', 'rust_analyzer', 'texlab', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

require("clangd_extensions").setup {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  },
  extensions = {
    -- defaults:
    -- Automatically set inlay hints (type hints)
    autoSetHints = false,
    -- Whether to show hover actions inside the hover window
    -- This overrides the default hover handler
    hover_with_actions = true,
    -- These apply to the default ClangdSetInlayHints command
    inlay_hints = {
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause  higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = "CursorHold",
      -- wheter to show parameter hints with the inlay hints or not
      show_parameter_hints = true,
      -- whether to show variable name before type hints with the inlay hints or not
      show_variable_name = false,
      -- prefix for parameter hints
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
    },
  }
}

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

require"lspconfig".gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes=true,
        compositeLiteralFields=true,
        constantValues=true,
        functionTypeParameters=true,
        parameterNames=true,
        rangeVariableTypes=true,
      }
    }
  }
}

require'lspconfig'.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}


-- vim.g.symbols_outline = {
--   highlight_hovered_item = true,
--   show_guides = true,
--   position = 'right',
--   keymaps = {
--     close = "<Esc>",
--     goto_location = "<Cr>",
--     focus_location = "o",
--     hover_symbol = "<C-space>",
--     rename_symbol = "r",
--     code_actions = "a",
--   },
--   lsp_blacklist = {},
-- }

local signs = { Error = " ", Warn = " ", Info = " ", Hint = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- local rt = require("rust-tools")
-- rt.setup()
--
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}
dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}
