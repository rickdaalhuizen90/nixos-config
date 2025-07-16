return {
  'ibhagwan/fzf-lua',
  config = function()
    local fzf = require('fzf-lua')

    -- Apply minimal configuration
    fzf.setup({
      --winopts = { split = 'belowright new' },
      files = {
        previewer = false,
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
    })

    -- Set up keymaps (Vscode)
    vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find Files' })
    vim.keymap.set('n', '<C-f>', fzf.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<C-b>', fzf.buffers, { desc = 'Show Buffers' })
    vim.keymap.set('n', '<C-h>', fzf.command_history, { desc = 'Command History' })
    vim.keymap.set('n', '<C-q>', fzf.quickfix, { desc = 'Quick Fix List' })
  end,
}
