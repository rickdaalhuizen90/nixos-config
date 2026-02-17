{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
  };

  home.file.".zshrc" = {
    source = ./zsh/.zshrc;
  };

  home.file."functions/" = {
    source = ./zsh/functions;
  };
}

