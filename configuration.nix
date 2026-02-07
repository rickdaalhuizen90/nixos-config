{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "9.9.9.9" "149.112.112.112"
    "2620:fe::fe" "2620:fe::9"
  ];

  networking.hosts = {
    "127.0.0.1" = [ "magento.app.test" "n8n.app.test" "odoo.app.test" "akeneo.app.test" ];
  };

  # Firewall
  networking.firewall.enable = true;
  networking.nftables.enable = true;

  # Localization
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "nl_NL.UTF-8";

  # Security
  security.rtkit.enable = true;

  # Desktop
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  services.fwupd.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    settings.General.ControllerMode = "bredr";
  };

  boot.extraModprobeConfig = ''
    options rtw89_pci disable_aspm=y
    options rtw89_core disable_ps_mode=y
    options bluetooth disable_ertm=1
  '';

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Power Management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_MAX_FREQ_ON_AC = "5132000";
      CPU_SCALING_MAX_FREQ_ON_BAT = "1200000";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  # Suspend/Hibernate
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=lock
      IdleActionSec=5min
    '';
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      extraPackages = [ pkgs.runc ];
    };
  };

  environment.etc."containers/containers.conf".text = lib.mkForce ''
    [engine]
    runtime = "runc"
    events_logger = "file"
    cgroup_manager = "cgroupfs"
  '';

  environment.variables = {
    GSK_RENDERER = "opengl";
    EDITOR = "vim";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "pipe-operators"];
    auto-optimise-store = true;
    trusted-users = [ "root" "${username}" ];
    cores = 0;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    steam.enable = true;
    nano.enable = false;
  };

  environment.systemPackages = with pkgs; [
    coreutils git curl wget htop
    powertop lm_sensors tree
    docker-buildx gnumake
    vlc unzip zstd sshfs
    usbutils pciutils
    dive podman-tui podman-compose
    iptables-nftables-compat
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = "Rick Daalhuizen";
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" "video" "render" ];
    shell = pkgs.zsh;
  };

  # Redroid Specifics
  boot.kernelParams = [
    "thinkpad_acpi.bios_charge_start_threshold=75"
    "thinkpad_acpi.bios_charge_stop_threshold=80"
    "acpi.ec_no_wakeup=1"
  ];

  boot.kernelPatches = [ {
    name = "redroid-config";
    patch = null;
    extraConfig = ''
      ANDROID_BINDER_IPC y
      ANDROID_BINDERFS y
    '';
  } ];

  boot.specialFileSystems."/dev/binderfs" = {
    device = "binder";
    fsType = "binder";
    options = [ "nofail" ];
  };

  systemd.tmpfiles.rules = [
    "d /dev/binderfs 0755 root root -"
  ];

  system.stateVersion = "25.05";
}
