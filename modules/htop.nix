{ config, pkgs, ... }:

let
  htoprc = pkgs.writeText "htoprc" ''
    show_cpu_temperature=1
    tree_view=0
    color_scheme=0
    hide_userland_threads=1
    hide_threads=1
    left_meters=AllCPUs2 Memory Swap
    left_meter_modes=1 1 1
    right_meters=Tasks Uptime Battery DiskIO NetworkIO
    right_meter_modes=2 2 1 2 3
    fields=0 48 46 47 1
  '';
in
{
  home.packages = with pkgs; [ htop ];

  xdg.configFile."htop/htoprc".source = htoprc;
}

