-- Set leader key before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable unused providers and netrw
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.opt.shadafile = 'NONE'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

-- General Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.scrolloff = 10
vim.opt.inccommand = 'split'
--vim.opt.background = 'light'
--vim.opt.textwidth = 80
--vim.opt.wrap = true
--vim.opt.linebreak = true
-- In your main init.lua
vim.opt.tags = { './tags;', 'tags' }

-- Language
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

-- Performance optimizations
vim.opt.updatetime = 200          -- Reduce time before swap and CursorHold
vim.opt.timeoutlen = 300          -- Faster key sequence timeout
vim.opt.synmaxcol = 200           -- Limit syntax highlighting to improve performance
vim.opt.fillchars = { eob = ' ' } -- Remove `~` at end of buffers

-- New in Neovim 0.11: Enable folds using treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false -- Disable folding by default

-- Set up statusline with LSP information (new in 0.11)
vim.opt.statusline = [[ %f %h%w%m%r %{%v:lua.require'lsp-status'.status()%} %=%-14.(%l,%c%V%) %P ]]

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
vim.keymap.set('n', '<Leader>w', ':w<CR>:source %<CR>',
    { noremap = true, silent = true, desc = 'Write and source the current file' })
vim.keymap.set('n', '<leader><Del>', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Open Oil file explorer' })
vim.keymap.set('n', '<Leader>g', '<cmd>Goyo<CR>', { desc = 'Toggle Goyo' })
vim.keymap.set('n', '<Leader>lc', '<cmd>VimtexCompile<CR>', { desc = 'Compile LaTex' })
vim.keymap.set('n', '<Leader>cw', '<cmd>VimtexCountWords<CR>', { desc = 'Count Words' })
vim.keymap.set('n', '<Leader>\\', ')', { desc = 'Go to next sentence' })
vim.keymap.set('n', "<Leader>'", '(', { desc = 'Go to previous sentence' })

-- Use new bytecode loader
vim.loader.enable()

-- Highlight text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    desc = 'Highlight text on yank',
})

-- @TODO: replace with vim.pack in 0.12
-- see: https://www.reddit.com/r/neovim/comments/1lriv80/comment/n1ayoeb/
-- Install `lazy.nvim` Plugin Manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Configure Plugins
require('lazy').setup({
    require 'plugins.nvim-lspconfig',
    require 'plugins.nvim-cmp',
    require 'plugins.which-key',
    require 'plugins.fzf-lua',
    require 'plugins.mini',
    require 'plugins.conform',
    require 'plugins.goyo',
    require 'plugins.treesitter',
    --require 'plugins.codeium',
    --require 'plugins.augment',
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            columns = {},
            view_options = {
                show_hidden = true,
            },
        },
        -- Optional dependencies
        dependencies = { { 'echasnovski/mini.icons', opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },
    {
        'tpope/vim-sleuth',                     -- Detect tabstop and shiftwidth automatically
        event = { 'BufReadPre', 'BufNewFile' }, -- Load after your file content
    },
    { 'Bilal2453/luvit-meta', lazy = true },

    -- New in Neovim 0.11: Native statusline plugin
    {
        'nvim-lua/lsp-status.nvim',
        event = 'LspAttach',
    },

    -- LaTex
    {
        'lervag/vimtex',
        lazy = false, -- we don't want to lazy load VimTeX
        tag = 'v2.16',
        init = function()
            vim.g.vimtex_view_method = 'zathura' -- skim for MacOS
            vim.g.vimtex_compiler_latexmk = {
                out_dir = 'out',
            }
        end,
    },
}, {
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})

vim.o.winborder = 'none'
