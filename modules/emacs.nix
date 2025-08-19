{ config, pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;

    extraPackages = (epkgs: with epkgs; [
      vterm
      pdf-tools
      (treesit-grammars.with-grammars (grammars: []))
    ]);

    extraConfig = ''
      ;; Load your init.el from the specified source
      (load-file "${./emacs/init.el}")
    '';
  };
}
