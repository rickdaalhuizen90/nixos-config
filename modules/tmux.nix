{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ tmux ];

  programs.tmux = {
    enable = true;
    clock24 = true;

    extraConfig = ''
      # Set prefix key to Ctrl-a (like GNU screen)
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # Default shell
      set -g default-shell ${pkgs.zsh}/bin/zsh

      # Pane styling
      set -g pane-border-style fg=colour238
      set -g pane-active-border-style fg=colour238

      # Disable mouse (makes copy/paste with system clipboard easier)
      set -g mouse off

      # Enable vi keybindings in copy mode
      setw -g mode-keys vi

      # Enable focus window events (useful for Vim/Neovim inside tmux)
      set-option -g focus-events on

      # Improve terminal color support
      set-option -as terminal-features ',xterm-256color:RGB'

      # Splits
      unbind '"'
      unbind %
      bind | split-window -h
      bind - split-window -v

      # Close window with confirmation
      bind-key Q confirm-before -p "kill-window #W? (y/n)" kill-window

      # Status bar
      set -g status on
    '';
  };
}

