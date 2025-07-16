{ config, pkgs, lib, username, ... }:

{

  home.packages = with pkgs; [ sops age ];

  sops.secrets = {
    "rclone/gdrive/client_id" = {
      sopsFile = ../secrets/secrets.yaml;
    };
    "rclone/gdrive/client_secret" = {
      sopsFile = ../secrets/secrets.yaml;
    };
    "rclone/gdrive/token" = {
      sopsFile = ../secrets/secrets.yaml;
    };
    "rclone/farida_onedrive/token" = {
      sopsFile = ../secrets/secrets.yaml;
    };
    "rclone/farida_gdrive/token" = {
      sopsFile = ../secrets/secrets.yaml;
    };
  };

  programs.rclone.enable = true;

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.templates."rclone-config-file" = {
    name = "rclone.conf";
    path = "${config.xdg.configHome}/rclone/rclone.conf";
    mode = "0600";
    content = ''
      [gdrive]
      type = drive
      client_id = ${config.sops.placeholder."rclone/gdrive/client_id"}
      client_secret = ${config.sops.placeholder."rclone/gdrive/client_secret"}
      token = ${config.sops.placeholder."rclone/gdrive/token"}
      scope = drive
      team_drive =

      [farida_onedrive]
      type = onedrive
      drive_id = 15CEDD6687CA7296
      drive_type = personal
      token = ${config.sops.placeholder."rclone/farida_onedrive/token"}

      [farida_gdrive]
      type = drive
      scope = drive
      team_drive =
      token = ${config.sops.placeholder."rclone/farida_gdrive/token"}
    '';
  };

  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Rclone Google Drive Mount";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      ExecStart = ''
      ${pkgs.rclone}/bin/rclone mount gdrive: ${config.home.homeDirectory}/gdrive \
        --config ${config.sops.templates."rclone-config-file".path} \
        --vfs-cache-mode writes \
        --log-level DEBUG \
        --log-file ${config.home.homeDirectory}/.local/share/rclone/rclone-gdrive.log
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -uz ${config.home.homeDirectory}/gdrive";
      Restart = "on-failure";
      RestartSec = 10;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.activation.createGDriveDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/gdrive"
    mkdir -p "$HOME/.local/share/rclone"
  '';
}
