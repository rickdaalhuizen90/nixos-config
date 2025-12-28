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

  # Localization
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "nl_NL.UTF-8";

  # Boot
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "amd_pstate=active"
    "nowatchdog"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Security
  security.rtkit.enable = true;

  # Desktop
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Power Management
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      USB_AUTOSUSPEND = 1;
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

  # Hardware - GPU (SIMPLIFIED - NixOS 25.05 handles DRI automatically)
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk  # Vulkan driver
    ];
  };

  # Virtualization
  #virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  # Applications
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };

  # Nix settings
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

  # Programs
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    steam.enable = true;
  };

  # System packages (llama.cpp is now optional - install via nix-shell when needed)
  environment.systemPackages = with pkgs; [
    coreutils git curl wget htop
    powertop lm_sensors
    docker-buildx gnumake
    vlc unzip
    usbutils pciutils
  ];

  # User
  users.users.${username} = {
    isNormalUser = true;
    description = "Rick Daalhuizen";
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
