return {
  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup()
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          'bashls',
          'dockerls',
          'docker_compose_language_service',
          'jsonls',
          'lua_ls',
          'marksman',
          'nil_ls',
          'pyright',
          'ts_ls',     -- ✅ replaces deprecated 'tsserver'
          'vimls',
          'yamlls',
        },
        automatic_installation = true,  -- auto-install any missing servers
        automatic_enable = true,        -- auto-setup LSPs (requires Neovim 0.11+)
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require("lspconfig")

      -- Set up installed servers
      lspconfig.bashls.setup({})
      lspconfig.dockerls.setup({})
      lspconfig.docker_compose_language_service.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.marksman.setup({})
      lspconfig.nil_ls.setup({})
      lspconfig.pyright.setup({})
      lspconfig.ts_ls.setup({})  -- ✅ ts_ls instead of tsserver
      lspconfig.vimls.setup({})
      lspconfig.yamlls.setup({})

      -- Keymaps for LSP functionality
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, {})
    end,
  },
}
