{ config, pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages = (epkgs: with epkgs; [
      pdf-tools
      evil
      evil-collection
      use-package
      magit
      forge
      mood-line
      modus-themes
      olivetti
      centered-cursor-mode
      markdown-mode
      ivy
      counsel
      which-key
      super-save
      darkroom
      (treesit-grammars.with-grammars (grammars: []))
    ]);
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };

  systemd.user.services.emacs.Service.WorkingDirectory = "/home/rick";

  home.file.".emacs.d/init.el" = {
    source = ./emacs/init.el;
  };

  home.file.".emacs.d/config.org" = {
    source = ./emacs/config.org;
  };
}

