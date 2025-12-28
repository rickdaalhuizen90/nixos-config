{ config, pkgs, ... }:

let
  aiderConfig = ''
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

  home.file.".aider.conf.yml".text = aiderConfig;
}

