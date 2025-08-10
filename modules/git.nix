{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Rick Daalhuizen";
    userEmail = "rick.daalhuizen@outlook.com";

    ignores = [
      ".DS_Store"
      "*.bak"
      "*~"
      "*.swp"
      "*.swo"
      "*.tmp"
      "*.log"
      "*.iml"
      ".idea/"
      ".vscode/"
      "target/"
      "node_modules/"
      "*.pyc"
      "__pycache__/"
    ];

    extraConfig = {
      core = {
        editor = "nano";
      };
      pull.rebase = false;
      color.ui = "auto";
      init.defaultBranch = "main";
    };
  };
}
