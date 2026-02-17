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

  networking.nftables.enable = true;
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ];
  };

  # Localization
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "nl_NL.UTF-8";

  # Security
  security.rtkit.enable = true;
  #security.pki.certificates = [ (builtins.readFile ./certificates/homeserver-root-ca.crt) ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.gnome.gnome-keyring.enable = true;
  services.fwupd.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    settings.General.ControllerMode = "bredr";
  };

  services.blueman.enable = true;

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

  # Brightness
  programs.light.enable = true;

  # File Manager
  programs.thunar.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

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
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=lock
      IdleActionSec=5min
    '';
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.displayManager.defaultSession = "sway";

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
    options = "--delete-older-than 14d";
    persistent = true;
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    steam.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    coreutils git curl wget htop
    powertop lm_sensors tree
    docker-buildx gnumake
    vlc unzip zstd sshfs
    usbutils pciutils
    dive podman-tui podman-compose
    iptables-nftables-compat gnome-disk-utility ncdu du-dust
    grim wl-clipboard mako brightnessctl wireplumber wev
    i3status rofi papirus-icon-theme nwg-displays libnotify
  ];

  services.udev.packages = [ pkgs.brightnessctl ];
  users.users.${username} = {
    isNormalUser = true;
    description = "Rick Daalhuizen";
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" "video" "render" "input" ];
    shell = pkgs.zsh;
  };

  services.udisks2.enable = true;
  security.polkit.enable = true;

  # Redroid Specifics
  boot.kernelParams = [
    "thinkpad_acpi.bios_charge_start_threshold=75"
    "thinkpad_acpi.bios_charge_stop_threshold=80"
    "acpi.ec_no_wakeup=1"
    "amd_pstate=active"
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
