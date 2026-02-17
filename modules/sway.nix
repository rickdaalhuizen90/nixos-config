{ config, pkgs, ... }:

{
  home.file.".config/sway/scripts/" = {
    source = ./sway/scripts;
  };

  home.file.".config/sway/config" = {
    source = ./sway/config;
  };

  home.file.".config/i3status/config" = {
    source = ./i3status/config;
  };
}
