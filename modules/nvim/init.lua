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
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.winborder = 'none'
vim.opt.clipboard = 'unnamedplus'
vim.opt.showcmd = false
vim.opt.termguicolors = true
vim.opt.conceallevel = 1
vim.opt.thesaurus:append("~/.config/nvim/thesaurus/mthesaur.txt")

vim.api.nvim_set_keymap('i', '--', '—', { noremap = true })

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight NormalFloat guibg=none
  highlight SignColumn guibg=none
]]

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

-- you can keep this, but blink does completion itself; this won’t hurt
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end
    end
})

-- PLUGINS ----------------------------------------------------------
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/saghen/blink.cmp' },
    { src = 'https://github.com/archie-judd/blink-cmp-words' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/echasnovski/mini.pick' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/junegunn/goyo.vim' },
    { src = 'https://github.com/echasnovski/mini.statusline' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    -- { src = 'https://github.com/maxmx03/solarized.nvim', },
})

require "nvim-treesitter".setup()
require "which-key".setup()
require "mini.pick".setup()
require "oil".setup()

-- BLINK.CMP --------------------------------------------------------
local blink = require("blink.cmp")

blink.setup({
    sources = {
        default = { "lsp", "path", "buffer", "snippets" },
        per_filetype = {
            markdown = { "thesaurus" },
            text = { "thesaurus" },
            asciidoctor = { "thesaurus" },
        },

        providers = {
            thesaurus = {
                name = "blink-cmp-words",
                module = "blink-cmp-words.thesaurus",
                opts = {
                    similarity_depth = 2,
                    similarity_pointers = { "&", "^" },
                    user_file = "~/.config/nvim/thesaurus/mthesaur.txt",
                },
                min_keyword_length = 5,
            },
        },
    },

    snippets = {
        preset = "luasnip",
    },

    fuzzy = {
        implementation = "lua",
    }

})

-- LSP --------------------------------------------------------------
-- blink has its own helper for LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

local servers = {
    "lua_ls", "rust_analyzer", "gopls", "marksman", "harper_ls",
    "intelephense", "eslint", "clangd", "html", "ts_ls",
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

    vim.lsp.config(server_name, opts)

    vim.lsp.enable(server_name)
end

-- intelephense extra
vim.lsp.config('intelephense', {
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

vim.lsp.enable('intelephense')

-- FZF --------------------------------------------------------------
local fzf = require('fzf-lua')
fzf.setup {
    files = {
        previewer = false,
        fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor --exclude .cache --exclude build --exclude dist --threads=8",
        rg_opts = "--color=never --files --hidden --follow --glob '!.git/*' --glob '!node_modules/*'",
    },
    grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --threads=8",
    },
    live_grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
        exec_empty_query = false,
    },
    winopts = {
        fullscreen = true,
        backdrop = 60,
        border = 'none',
        preview = {
            border = 'none'
        }
    }
}

vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find Files' })
vim.keymap.set('n', '<C-f>', fzf.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<C-b>', fzf.buffers, { desc = 'Show Buffers' })
vim.keymap.set('n', '<C-h>', fzf.command_history, { desc = 'Command History' })
vim.keymap.set('n', '<C-q>', fzf.quickfix, { desc = 'Quick Fix List' })

-- FORMATTER --------------------------------------------------------
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

-- STATUSLINE -------------------------------------------------------
require('mini.statusline').setup {
    content = {
        active = nil,
        inactive = nil,
    },
    use_icons = vim.g.have_nerd_font,
    set_vim_settings = true,
}

-- HARPER -----------------------------------------------------------
vim.lsp.config('harper_ls', {
    filetypes = { "markdown", "text", "latex" },
    settings = {
        ["harper-ls"] = {
            userDictPath = "",
            workspaceDictPath = "",
            fileDictPath = "",
            linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,
                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                Matcher = true,
                CorrectNumberSuffix = true
            },
            codeActions = {
                ForceStable = false
            },
            markdown = {
                IgnoreLinkTitle = false
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "American",
            maxFileLength = 120000,
            ignoredLintsPath = "",
            excludePatterns = {}
        }
    }
})

vim.lsp.enable('harper_ls')

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
