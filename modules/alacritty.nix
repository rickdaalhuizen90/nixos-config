{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
  };

  home.file.".config/alacritty/alacritty.toml".text =
    (builtins.readFile ./alacritty/alacritty.toml) +
    "\n" +
    (builtins.readFile ./alacritty/themes/inferno.toml);
}
