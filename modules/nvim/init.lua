vim.g.mapleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.winborder = 'none'
vim.opt.clipboard = 'unnamedplus'
vim.opt.showcmd = false
vim.opt.termguicolors = true;
vim.opt.background = 'light';

vim.keymap.set('n', '<leader>w', ':write<CR>:source %<CR>', { desc = "Save and source current file" })
vim.keymap.set('n', '<leader><Del>', ':bdelete<CR>', { desc = "Close current buffer" })
vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open Oil file explorer' })
vim.keymap.set('n', '<leader>t', function()
    vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
end)

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    desc = 'Highlight text on yank',
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end
    end
})

vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/hrsh7th/nvim-cmp' },
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/echasnovski/mini.pick' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/junegunn/goyo.vim' },
    { src = 'https://github.com/echasnovski/mini.statusline' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons', },
    --{ src = 'https://github.com/maxmx03/solarized.nvim', },
})

require "nvim-treesitter".setup()
require "which-key".setup()
require "mini.pick".setup()
require "oil".setup()

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {
    "lua_ls", "elixirls", "marksman", "harper_ls",
    "intelephense", "eslint", "clangd", "ts_ls",
}

local on_attach = function(client, bufnr)
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, buffer = bufnr }

    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    map('n', '<C-CR>', vim.lsp.buf.code_action, opts)
    map('i', '<C-CR>', vim.lsp.buf.code_action, opts)
end

for _, server_name in ipairs(servers) do
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    if server_name == "lua_ls" then
        opts.settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        }
    end
    lspconfig[server_name].setup(opts)
end

lspconfig.intelephense.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        intelephense = {
            completion = {
                fullyQualifyGlobalConstantsAndFunctions = false,
                insertUseDeclaration = true,
                maxItems = 100,
            },
            diagnostics = {
                undefinedTypes = false,
                undefinedFunctions = false,
                undefinedConstants = false,
            },
        }
    },
})

local fzf = require('fzf-lua')
fzf.setup {
    files = {
        previewer = false,
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
    },
    winopts = {
        fullscreen = true,
        backdrop = 60,
        border = 'none',
    }
}

vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find Files' })
vim.keymap.set('n', '<C-f>', fzf.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<C-b>', fzf.buffers, { desc = 'Show Buffers' })
vim.keymap.set('n', '<C-h>', fzf.command_history, { desc = 'Command History' })
vim.keymap.set('n', '<C-q>', fzf.quickfix, { desc = 'Quick Fix List' })

local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
        }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    },
    confirmation = {
        get_commit_characters = function(commit_characters)
            return commit_characters
        end
    },
}

require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
            return
        end
        return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters_by_ft = {
        lua = { 'stylua' },
    },
}

vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
    require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format buffer' })

require('mini.statusline').setup {
    content = {
        active = nil,
        inactive = nil,
    },
    use_icons = vim.g.have_nerd_font,
    set_vim_settings = true,
}

--require('solarized').setup()
--vim.cmd("colorscheme solarized")
