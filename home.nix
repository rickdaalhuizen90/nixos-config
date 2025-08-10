{ config, pkgs, lib, username, ... }:

{
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  xdg.configFile."nix/nix.conf".text = ''
    warn-dirty = false
  '';

  imports = [
    ./modules/rclone.nix
    ./modules/alacritty.nix
    ./modules/zsh.nix
    ./modules/tmux.nix
    ./modules/git.nix
    ./modules/htop.nix
    ./modules/nvim.nix
    #./modules/aider.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    android-studio
    anki
    wireshark-qt
    obsidian
    ghidra-bin
    burpsuite
    libreoffice
    mitmproxy
    vlc
    gtimelog
    signal-desktop
    transmission_4-qt
    steam
    zoxide
    dust
    ripgrep
    fzf
    wl-clipboard
    pandoc
    gemini-cli
    valgrind
    nerd-fonts.hack
    lua-language-server
    nodePackages.typescript-language-server
    vscode-langservers-extracted
    ollama
    direnv
    jadx
    frida-tools
    apktool
    minikube
    kubectl
    kubernetes-helm
    k9s
    inotify-tools
    harper
    marksman
    android-tools
    pipx
    python313Packages.numpy
    yt-dlp
    spotdl
    logseq
    zotero
  ];

  fonts.fontconfig.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = 1;
    FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --no-ignore-vcs --glob \"!{node_modules/*,.git/*,vendor/*,dist/*,build/*}\"";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];
}

