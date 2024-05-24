return {
    {
        'williamboman/mason.nvim',
        dependencies = {
          "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            local mason = require("mason")

            local mason_tool_installer = require("mason-tool-installer")

            -- enable mason and configure icons
            mason.setup()

            mason_tool_installer.setup({
              ensure_installed = {
                "prettier", -- prettier formatter
                "stylua", -- lua formatter
                "isort", -- python formatter
                "black", -- python formatter
                "pylint", -- python linter
                "eslint_d", -- js linter
              },
            })
          end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup(
                {
                    ensure_installed = {
                        'bashls',
                        'dockerls',
                        'docker_compose_language_service',
                        'jsonls',
                        'lua_ls',
                        'marksman',
                        'pyright',
                        'tsserver',
                        'vimls',
                        'yamlls',
                    },
                })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.bashls.setup{}
            lspconfig.dockerls.setup{}
            lspconfig.docker_compose_language_service.setup{}
            lspconfig.jsonls.setup{}
            lspconfig.lua_ls.setup{}
            lspconfig.marksman.setup{}
            lspconfig.pyright.setup{}
            lspconfig.tsserver.setup{}
            lspconfig.vimls.setup{}
            lspconfig.yamlls.setup{}

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, {})
        end
    },
}
