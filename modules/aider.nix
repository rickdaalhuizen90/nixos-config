{ config, pkgs, ... }:

let
  aiderConfig = pkgs.writeText "aider.conf.yml" ''
    model: openrouter/deepseek/deepseek-v3.2
    weak-model: ollama_chat/llama3.2:latest
    edit-format: diff
    reasoning-effort: medium
    attribute-co-authored-by: true
    dark-mode: true
    editor: vim
    show-diffs: true
    stream: true
    cache-prompts: true
    read: CONVENTIONS.md
    skip-sanity-check-repo: true
    add-gitignore-files: true
  '';
in
{
  home.packages = with pkgs; [ aider-chat ];

  xdg.configFile."aider/aider.conf.yml".source = aiderConfig;
}

