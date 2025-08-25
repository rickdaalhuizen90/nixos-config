{ config, pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages = (epkgs: with epkgs; [
      vterm
      pdf-tools
      evil
      evil-collection
      use-package
      magit
      forge
      (treesit-grammars.with-grammars (grammars: []))
    ]);
  };

  services.emacs = {
    enable = true;
  };

  home.file.".config/emacs/init.el" = {
    source = ./emacs/init.el;
  };

  home.file.".config/emacs/config.org" = {
    source = ./emacs/config.org;
  };
}

