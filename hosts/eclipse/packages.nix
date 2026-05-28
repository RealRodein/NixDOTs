{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    niri
    chromium
    ghostty
    btop
    git
    inputs.noctalia.packages.${pkgs.system}.default
  ];
}
