{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [ sops age rclone ];

  sops.secrets = {
  };

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  sops.templates."rclone-config-file" = {
    name = "rclone.conf";
    path = "${config.xdg.configHome}/rclone/rclone.conf";
    mode = "0600";
    content = ''
      [hetzner-sftp]
      type = sftp
      host = u524188.your-storagebox.de
      user = u524188
      port = 23
      key_file = ${config.home.homeDirectory}/.ssh/id_ed25519
      ssh_cmd = ${pkgs.openssh}/bin/ssh -o ServerAliveInterval=60
    '';
  };

  home.activation.createRcloneDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/rclone"
  '';
}
