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
    ./modules/emacs.nix
    #./modules/aider.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    android-tools
    anki
    wireshark-qt
    obsidian
    ghidra-bin
    burpsuite
    libreoffice
    mitmproxy
    vlc
    signal-desktop
    #transmission_4-qt
    qbittorrent
    zoxide
    dust
    ripgrep
    fzf
    jq
    wl-clipboard
    pandoc
    gemini-cli
    valgrind
    lua-language-server
    nodePackages.typescript-language-server
    vscode-langservers-extracted
    ollama
    direnv
    jadx
    frida-tools
    apktool
    k3d
    kubectl
    kubernetes-helm
    k9s
    inotify-tools
    harper
    marksman
    pipx
    yt-dlp
    spotdl
    logseq
    zotero
    intelephense
    fira-code
    nerd-fonts.hack
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
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];
}

