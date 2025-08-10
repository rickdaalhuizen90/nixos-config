{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

   # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # Localization
  time.timeZone = "Europe/Brussels";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings.LC_TIME = "nl_NL.UTF-8";
  };

  # Desktop environment
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    printing.enable = true;

    # Power management - TLP configuration
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_DRIVER_OPMODE_ON_AC = "passive";
        CPU_DRIVER_OPMODE_ON_BAT = "passive";
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        RADEON_DPM_PERF_LEVEL_ON_AC = "high";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
        USB_AUTOSUSPEND = 1;
        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersupersave";
      };
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Applications
    ollama = {
      enable = true;
      loadModels = [ "llama3.1:8b" "qwen2.5-coder:7b" "gemma3n:e2b" ];
      acceleration = "rocm";
    };
    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      settings.download-dir = "${config.services.transmission.home}/Downloads";
    };
    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      ensureUsers = [{ name = "postgres"; }];
    };
  };

  # Security and power management
  security.rtkit.enable = true;
  powerManagement.enable = true;

  # Virtualization
  virtualisation = {
    waydroid.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        dns = [ "1.1.1.1" "8.8.8.8" ];
        log-driver = "journald";
        registry-mirrors = [ "https://mirror.gcr.io" ];
        storage-driver = "overlay2";
      };
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # Package and program configuration
  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
    android_sdk.accept_license = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];

  programs = {
    firefox.enable = true;
    zsh.enable = true;
    java.package = pkgs.jdk21;
    fuse.userAllowOther = true;
  };

  # System packages
  environment = {
    systemPackages = with pkgs; [
      coreutils wget curl git gnupg age gcc
      htop tree zip docker-buildx qemu gnumake
    ];
    gnome.excludePackages = with pkgs; [ gedit totem geary ];
  };

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    description = "Rick Daalhuizen";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}

