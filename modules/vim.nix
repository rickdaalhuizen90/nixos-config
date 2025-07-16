{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.vim_configurable.customize {
      name = "vim-with-config";
      vimrcConfig.customRC = ''
        " Terminal Behaviour
        set ttyfast
        set ttimeout
        set ttimeoutlen=50
        set mouse=v
        set clipboard=unnamed
        set backspace=indent,eol,start
        set autoindent
        set showmatch
        set nowrap
        set wildmode=longest,list,full

        " Search & Replace
        set ignorecase
        set smartcase

        " Appearance & Theming
        syntax enable
        set t_Co=256
        set termguicolors
        set background=dark
        set number
        set relativenumber
        set laststatus=2
        set signcolumn=no
        set guicursor+=a:blinkon0
        set hlsearch
        filetype plugin indent on
        set linespace=3
        set ts=2 sw=2 expandtab smarttab

        " Key Mapping
        let g:mapleader = ","
        nmap <leader>s :set invspell<CR>
        set spelllang=en
        set splitbelow
        set splitright
        nmap <leader>v :vsplit<CR>
        nmap <leader>s :split<CR>
        nmap <C-h> <C-w>h
        nmap <C-j> <C-w>j
        nmap <C-k> <C-w>k
        nmap <C-l> <C-w>l
      '';
    })
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

