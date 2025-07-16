{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    fd
    unzip
    (python3.withPackages (ps: with ps; [ pynvim ]))
    # Add latexmk/zathura etc. if needed for VimTeX
  ];

  xdg.configFile."nvim/init.lua".source = ../nvim/init.lua;
  xdg.configFile."nvim/lua".source = ../nvim/lua;
  xdg.configFile."nvim/lazy-lock.json".source = ../nvim/lazy-lock.json;
}

