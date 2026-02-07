{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
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
      set spelllang=en
      set splitbelow
      set splitright

      " Fixed: Mapping conflict. <leader>s was used for both spell and split.
      nmap <leader>sp :set invspell<CR>
      nmap <leader>v :vsplit<CR>
      nmap <leader>s :split<CR>

      " Window Navigation
      nmap <C-h> <C-w>h
      nmap <C-j> <C-w>j
      nmap <C-k> <C-w>k
      nmap <C-l> <C-w>l
    '';
  };
}
