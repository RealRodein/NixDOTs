{ config, lib, pkgs, inputs, ... }:

{
  # --- Boot ---
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    editor = false;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "udev.log_level=3"
    "vt.global_cursor_default=0"
    "nowatchdog"
    "intel_pstate=no_turbo"
  ];

  # --- System ---
  networking.hostName = "orbiter";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Prague";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    cores = 0;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old-generations 5";
  };

  # --- Display / Desktop ---
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "niri-session";
      user = "rodein";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config.niri = {
      default = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  services.xserver.xkb = {
    layout = "cz";
    variant = "coder";
    options = "ctrl:rctrl_shift";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  fonts.packages = with pkgs; [ inter ];

  # --- Audio ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # --- Hardware ---
  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  programs.dconf.enable = true;
  programs.fish.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override { extraArgs = "-cef-disable-gpu-compositing"; };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Force Full RGB on HDMI to fix washed-out colors
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords="RMForceFullRangeRGB=1"
  '';

  # --- Kernel ---
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- ASUS / GPU switching ---
  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  services.asusd.enable = true;
  # services.supergfxd.enable = true;

  # --- Power ---
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;

  # Poll no_turbo every 1s — asusd re-enables it otherwise
  systemd.services.disable-turbo = {
    description = "Keep Intel Turbo Boost disabled";
    wantedBy = [ "multi-user.target" ];
    after = [ "sysinit.target" ];
    before = [ "asusd.service" "auto-cpufreq.service" ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "1s";
      ExecStart = "${pkgs.writeShellScript "disable-turbo" ''
        while true; do
          echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
          sleep 1
        done
      ''}";
    };
  };

  systemd.services.auto-cpufreq = {
    description = "auto-cpufreq - Automatic CPU speed & power optimizer";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.bash ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.auto-cpufreq}/bin/auto-cpufreq --daemon";
      Restart = "on-failure";
    };
  };

  # --- Misc services ---
  services.openssh.enable = true;
  
  system.stateVersion = "25.11";
}
