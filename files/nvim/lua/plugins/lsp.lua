return {
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
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
