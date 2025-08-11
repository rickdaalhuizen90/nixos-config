{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = (epkgs: with epkgs; [
      vterm
      pdf-tools
      treesit-grammars.with-all-grammars
    ]);
  };

  xdg.configFile."emacs/init.el".source = ../emacs/init.el;
}

