{ config, lib, pkgs, inputs, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
    editor = false;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # silent boot
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "udev.log_level=3"
    "vt.global_cursor_default=0"
  ];

  networking.hostName = "eclipse";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "niri-session";
      user = "rodein";
    };
  };

  services.openssh.enable = true;
  services.libinput.enable = true;

  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.xserver.xkb = {
    layout = "cz";
    variant = "coder";
    options = "ctrl:rctrl_shift";
  };

  fonts.packages = with pkgs; [
    inter
  ];

  system.stateVersion = "25.11";
}
