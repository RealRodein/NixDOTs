
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
 
  boot.kernelParams = ["quiet" "splash"];
  #consoleLogLevel=0;
  #initrd.verbose = false;

  # - unfree packages
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = ["nvidia"];

  # - hardware 
  hardware.graphics = { enable = true; };
  hardware.nvidia = {
    modesetting.enable = true; # for wayland compositors
    open = true; # open source kernel modules
    nvidiaSettings = true; # for menu
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable; # driver version
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # ---

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  services.displayManager.sddm.enable = true; # - enables sddm
  services.xserver.enable = true; # - might be needed for Xwayland
  services.displayManager.sddm.wayland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL ="1"; # - fixes electron apps in wayland

  # - Desktop enviroment
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cz";
    variant = "coder"; # - layout
  };

  # Configure console keymap
  console.keyMap = "cz-lat2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rodein = {
    isNormalUser = true;
    description = "the Rodein";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [];
  };

  # - USING SOUND
  #sound.enable = true;
  services = { pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = { enable = true; support32Bit = true;};
    jack.enable = true;
  };};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pciutils lshw vscode discord steam asusctl git
    waybar cava hyprshot swww kitty fastfetch rofi-wayland
  ];

  # fonts
  fonts.packages = with pkgs; [
    font-awesome jetbrains-mono
  ];

  #enable zsh and ohmy
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
