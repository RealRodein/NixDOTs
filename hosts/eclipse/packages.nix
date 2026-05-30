{ pkgs, inputs, ... }:
{
  programs.appimage.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Desktop
    niri
    ghostty
    yazi
    opencode
    steam
    xwayland
    xwayland-satellite
    vesktop
    pavucontrol
    mpv
    
    # CLI tools
    btop
    git
    p7zip

    # ASUS
    asusctl
    supergfxctl

    # Power
    auto-cpufreq

    # Custom
    inputs.noctalia.packages.${pkgs.system}.default
    inputs.helium.packages.${pkgs.system}.default
  ];
}
