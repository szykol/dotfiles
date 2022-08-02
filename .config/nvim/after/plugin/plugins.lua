local cmp = require'cmp'
local types = require('cmp.types')
local mapping = require('cmp.config.mapping')
local lspkind = require('lspkind')

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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'spell' },
    }),
    formatting = {
      format = lspkind.cmp_format({with_text = true, maxwidth = 50})
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require("lspconfig")
local virtual_types = require("virtualtypes")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  virtual_types.on_attach(client, buffer)

  if client.supports_method('textDocument/codeLens') then
    require'virtualtypes'.on_attach(client, bufnr)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>sd', '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>sc', '<cmd>lua require"lspsaga.diagnostic".show_cursor_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>sk', '<cmd>lua require"lspsaga.diagnostic".navigate "prev"()<CR>', opts)
  buf_set_keymap('n', '<leader>sj', '<cmd>lua require"lspsaga.diagnostic".navigate "next"()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = { 'pyright', 'vimls', 'rust_analyzer', 'texlab', 'tsserver', 'gopls' }
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
    autoSetHints = true,
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

-- local system_name
-- if vim.fn.has("mac") == 1 then
--   system_name = "macOS"
-- elseif vim.fn.has("unix") == 1 then
--   system_name = "Linux"
-- elseif vim.fn.has('win32') == 1 then
--   system_name = "Windows"
-- else
--   print("Unsupported system for sumneko")
-- end

-- local home = vim.fn.expand('$HOME')
-- local sumneko_root_path = home .. '/dev/lua-language-server'
-- local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

-- require'lspconfig'.sumneko_lua.setup {
--   on_attach = on_attach,
--   cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
--   settings = {
--     Lua = {
--       runtime = {
--         version = 'LuaJIT',
--         path = vim.split(package.path, ';'),
--       },
--       diagnostics = {
--         globals = {'vim'},
--       },
--       workspace = {
--         library = {
--           [vim.fn.expand('$VIMRUNTIME/lua')] = true,
--           [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
--         },
--       },
--     },
--   },
-- }


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

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

require('colorbuddy').colorscheme('cobalt2')
