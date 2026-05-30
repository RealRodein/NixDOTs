{ config, lib, pkgs, inputs, ... }:

{
  # --- Boot ---
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    editor = false;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "udev.log_level=3"
    "vt.global_cursor_default=0"
    "mem_sleep_default=deep"
  ];

  # --- System ---
  networking.hostName = "eclipse";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Prague";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # --- Display / Desktop ---
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "niri-session";
      user = "rodein";
    };
  };

  services.xserver.xkb = {
    layout = "cz";
    variant = "coder";
    options = "ctrl:rctrl_shift";
  };

  fonts.packages = with pkgs; [ inter ];

  # --- Hardware ---
  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # --- ASUS / GPU switching ---
  services.asusd.enable = true;
  services.supergfxd.enable = true;

  # --- Power ---
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;

  systemd.services.auto-cpufreq = {
    description = "auto-cpufreq - Automatic CPU speed & power optimizer";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.auto-cpufreq}/bin/auto-cpufreq --daemon";
      Restart = "on-failure";
    };
  };

  powerManagement = {
    powerDownCommands = ''
      ${pkgs.systemd}/bin/runuser -u rodein -- sh -c '
        XDG_RUNTIME_DIR=/run/user/1000 \
        DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
        WAYLAND_DISPLAY=wayland-1 \
        ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia msg screen-lock
      '
    '';
    resumeCommands = ''
      sleep 1
      ${pkgs.systemd}/bin/runuser -u rodein -- sh -c '
        XDG_RUNTIME_DIR=/run/user/1000 \
        DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
        WAYLAND_DISPLAY=wayland-1 \
        ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia msg dpms-on
      '
    '';
  };

  # --- Misc services ---
  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
