{ config, pkgs, ... }:

{
  home.username = "rodein";
  home.homeDirectory = "/home/rodein";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
    git
    ghostty chromium
  ];

  programs.git.enable = true;
}
