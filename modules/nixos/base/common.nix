{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.allowedUDPPorts = [ 4950 4955 ]; # Warframe peer-to-peer
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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;

  programs.dconf.enable = true;
  programs.fish.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;
  services.flatpak.enable = true;
}
