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
    #./modules/htop.nix
    ./modules/nvim.nix
    ./modules/emacs.nix
    ./modules/aider.nix
  ];

  home.packages = with pkgs; [
    rustup
    gcc
    binutils
    radare2
    tailscale
    gdb
    gef
    aflplusplus
    nmap
    ltrace
    strace
    android-tools
    languagetool
    anki
    hunspell
    hunspellDicts.en_US
    wireshark-qt
    obsidian
    ghidra-bin
    burpsuite
    libreoffice
    calibre
    pcsx2
    mitmproxy
    btop
    jdupes
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
    bitwarden
    bitwarden-cli
    jq
    yq
    wl-clipboard
    xclip
    pandoc
    asciidoctor
    nodejs_24
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
    bun
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
    dejavu_fonts
    iosevka
    sops
  ];

  services.ollama = {
    enable = true;
  };

  sops.secrets."openrouter/api_key" = {
    sopsFile = ./secrets/secrets.yaml;
  };

  programs.zsh.initContent = ''
    export OPEROUTER_API_KEY="${config.sops.placeholder."openrouter/api_key"}"
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
    OLLAMA_API_BASE = "http://127.0.0.1:11434";
    DOCKER_HOST=unix:///var/run/podman/podman.sock;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  programs.ssh.enable = true;

  programs.ssh.extraConfig = ''
    Host backup
      HostName u524188.your-storagebox.de
      User u524188
      Port 23
      IdentityFile ~/.ssh/id_ed25519
      ServerAliveInterval 60
      ServerAliveCountMax 3
      TCPKeepAlive yes
      Compression yes
    Host home
      HostName 192.168.1.30
      User rick
      Port 22
      #IdentityFile ~/.ssh/id_ed25519
      ServerAliveInterval 60
      ServerAliveCountMax 3
      TCPKeepAlive yes
      Compression yes
  '';

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
}

