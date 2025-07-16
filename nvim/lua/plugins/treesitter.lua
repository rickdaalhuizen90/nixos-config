return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSSync",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "elixir", "eex", "heex", "lua", "vim" },
            highlight = {
                enable = true,
            },
        })
    end,
}
