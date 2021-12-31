-- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
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
      native_menu = false,
      ghost_text = true
    },
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    }),
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
  })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  if client.supports_method('textDocument/codeLens') then
    require'virtualtypes'.on_attach(client, bufnr)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- testing this out, might eventually move back to previous mechanism
  buf_set_keymap('n', 'gd', '<cmd>lua require"lspsaga.provider".preview_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', opts)
  buf_set_keymap('n', '<leader>sd', '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>sc', '<cmd>lua require"lspsaga.diagnostic".show_cursor_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>sk', '<cmd>lua require"lspsaga.diagnostic".navigate "prev"()<CR>', opts)
  buf_set_keymap('n', '<leader>sj', '<cmd>lua require"lspsaga.diagnostic".navigate "next"()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = {'vimls', 'rust_analyzer', 'clangd', 'texlab', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

nvim_lsp['pyright'].setup({
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  on_init = function(client)
    local orig_rpc_request = client.rpc.request
    function client.rpc.request(method, params, handler, ...)
      local orig_handler = handler
      if method == 'textDocument/completion' then
        -- Idiotic take on <https://github.com/fannheyward/coc-pyright/blob/6a091180a076ec80b23d5fc46e4bc27d4e6b59fb/src/index.ts#L90-L107>.
        handler = function(...)
          local err, result = ...
          if not err and result then
            local items = result.items or result
            for _, item in ipairs(items) do
              if not (item.data and item.data.funcParensDisabled) and (
                item.kind == vim.lsp.protocol.CompletionItemKind.Function or
                item.kind == vim.lsp.protocol.CompletionItemKind.Method or
                item.kind == vim.lsp.protocol.CompletionItemKind.Constructor
              ) then
                item.insertText = item.label .. '($1)$0'
                item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
              end
            end
          end
          return orig_handler(...)
        end
      end
      return orig_rpc_request(method, params, handler, ...)
    end
  end;
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local home = vim.fn.expand('$HOME')
local sumneko_root_path = home .. '/dev/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require'lspconfig'.sumneko_lua.setup {
  on_attach = on_attach,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
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

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "cpp", "bash", "python", "typescript", "javascript" },
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
}

local telescope = require"telescope"
telescope.setup{}
telescope.load_extension('project')
telescope.load_extension('refactoring')

require("trouble").setup{}

vim.g.symbols_outline = {
  highlight_hovered_item = true,
  show_guides = true,
  position = 'right',
  keymaps = {
    close = "<Esc>",
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    rename_symbol = "r",
    code_actions = "a",
  },
  lsp_blacklist = {},
}

require("todo-comments").setup {}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

require"nvim-tree".setup {}
require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  size = 10 or function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = false,
  start_in_insert = false,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
}

local dap_python = require('dap-python')
dap_python.setup('~/.virtualenvs/debugpy/bin/python')
dap_python.test_runner = "pytest"

require("dapui").setup()

require('tabline_framework').setup {
  render = function(f)
    f.add '   '

    f.make_tabs(function(info)
      f.add(' ' .. info.index .. ' ')
      f.add(info.filename or '[no name]')
      f.add(info.modified and '+')
      f.add ' '
    end)
  end,
}

local null_ls = require("null-ls")

-- register any number of sources simultaneously
local sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.diagnostics.flake8,
    -- null_ls.builtins.diagnostics.gccdiag,
    -- null_ls.builtins.diagnostics.write_good,
    -- null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup({ sources = sources })
