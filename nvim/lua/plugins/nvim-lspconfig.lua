return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'hrsh7th/nvim-cmp',
        { 'hrsh7th/cmp-nvim-lsp', event = 'LspAttach' },
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        local lspconfig = require('lspconfig')
        local util = require('lspconfig.util')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local on_attach = function(client, bufnr)
            local buf_set_keymap = vim.api.nvim_buf_set_keymap
            local opts = { noremap = true, silent = true }

            if client and client.server_capabilities.completionProvider then
                -- Make sure autotrigger is set to false if nvim-cmp handles triggering
                -- This ensures 'additionalTextEdits' are processed when you confirm a completion.
                vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
            end

            if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end

            buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
            buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
        end

        lspconfig.clangd.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = { "clangd", "--background-index", "-j=12" },
            root_dir = util.root_pattern("compile_commands.json", ".clangd", ".git"),
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        }

        lspconfig.ts_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
        }

        lspconfig.eslint.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern('.eslintrc.js', '.eslintrc.json', 'package.json', '.git'),
        }

        lspconfig.intelephense.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern("composer.json", ".git"),
            settings = {
                intelephense = {
                    completion = {
                        fullyQualifyCompletionTextEdits = false,
                        insertUseDeclaration = true,
                        triggerParameterHints = true,
                    },
                    format = {
                        enable = true
                    },
                    files = {
                        associations = { "*.php", "*.phtml" }
                    },
                    stubs = {
                        "Core", "PDO",
                    },
                    environment = {
                        includePaths = {
                            "~/Code/VoIP_Web"
                        },
                    },
                },
            },
        }

        lspconfig.harper_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "markdown", "rst", "org", "txt" },
        }

        lspconfig.jdtls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern('pom.xml', 'build.gradle', '.git'),
        }

        lspconfig.kotlin_language_server.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern('build.gradle', 'settings.gradle', '.git', 'pom.xml'),
        }

        lspconfig.elixirls.setup {
            cmd = { "elixir-ls" },
            settings = {
                elixirLS = {
                    dialyzerEnabled = false,
                    fetchDeps = false
                }
            }
        }

        lspconfig.lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                },
            },
        }

        lspconfig.marksman.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "markdown" },
        }
    end,
}
