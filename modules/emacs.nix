{ config, pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages = (epkgs: with epkgs; [
      vterm
      pdf-tools
      evil-collection
      use-package
      magit
      forge
      web-mode
      scss-mode
      typescript-mode
      python-mode
      php-mode
      go-mode
      lua-mode
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

