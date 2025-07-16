{ config, pkgs, ... }:

let
  aiderConfig = pkgs.writeText "aider.conf.yml" ''
    model: openrouter/openai/gpt-4o-mini
    weak-model: ollama/qwen2.5-coder:1.5b
    attribute-commit-message-author: true
    dark-mode: true
    editor: vim
    show-diffs: true
    stream: true
    cache-prompts: true
    read: CONVENTIONS.md
  '';
in
{
  home.packages = with pkgs; [ aider-chat ];

  xdg.configFile."aider/aider.conf.yml".source = aiderConfig;
}

