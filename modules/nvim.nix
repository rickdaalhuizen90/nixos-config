{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    fd
    (python3.withPackages (ps: with ps; [ pynvim ]))
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    viAlias = true;
    vimAlias = false;
  };

  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua".source = ./nvim/lua;
}

