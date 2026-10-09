{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    package = pkgs.steam.override { extraArgs = "-cef-disable-gpu-compositing"; };
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  networking.firewall.allowedUDPPorts = [ 4950 4955 ]; # Warframe peer-to-peer

  environment.systemPackages = with pkgs; [
    gamescope
    mangohud
    heroic
    prismlauncher
  ];
}
