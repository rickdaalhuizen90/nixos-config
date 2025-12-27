{ config, pkgs, lib, ... }:

let
  zshFunctionsDir = ./zsh/functions;
  functionFiles = lib.attrNames (builtins.readDir zshFunctionsDir);

  allFunctionsContent = lib.concatStringsSep "\n\n" (
    lib.filter (file: lib.hasSuffix ".zsh" file) functionFiles
    |> lib.map (file: builtins.readFile (zshFunctionsDir + "/${file}"))
  );
in
{
  home.packages = with pkgs; [
    fzf
    ripgrep
    pnpm
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      q   = "exit";
      l   = "ls -CF";
      ll  = "ls -lSh";
      la  = "ls -A";
      cl  = "clear";
      open = "xdg-open";
      docker = "podman";
    };

    history = {
      size = 1000;
      save = 1000;
    };

    initContent = ''
      setopt PROMPT_SUBST
      PROMPT='%F{green}%*%f %F{blue}%~%f $ '

      ${allFunctionsContent}
    '';
  };
}

