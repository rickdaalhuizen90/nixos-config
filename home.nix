{ config, pkgs, lib, username, ... }:

{
  home.stateVersion = "25.05";
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
    ./modules/aider.nix
  ];

  home.packages = with pkgs; [
    rustc
    cargo
    google-chrome
    android-tools
    languagetool
    anki
    hunspell
    hunspellDicts.en_US
    teams
    wireshark-qt
    obsidian
    ghidra-bin
    burpsuite
    libreoffice
    calibre
    pcsx2
    mitmproxy
    vlc
    signal-desktop
    #transmission_4-qt
    ghostty
    lmstudio
    qbittorrent
    zoxide
    novelwriter
    intelephense
    uv
    dust
    ripgrep
    fzf
    ffmpeg_6-headless
    jq
    wl-clipboard
    xclip
    pandoc
    asciidoctor
    nodejs_24
    #llama-cpp
    github-copilot-intellij-agent
    valgrind
    lua-language-server
    nodePackages.typescript-language-server
    vscode-langservers-extracted
    llama-cpp
    gemini-cli
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
    python312Packages.pip
    yt-dlp
    spotdl
    logseq
    zotero
    lua
    lua-language-server
    typescript
    typescript-language-server
    vscode-langservers-extracted
    go
    gopls
    clang-tools
    cascadia-code
    nerd-fonts.hack
    google-fonts
    iosevka
    sops
  ];

  sops.secrets.openai_key = {
    sopsFile = ./secrets/secrets.yaml;
    key      = "OPENAI_API_KEY";
  };

  programs.zsh.initContent = ''
export OPENAI_API_KEY="$(<"${config.sops.secrets.openai_key.path}")"
'';

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

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
}

