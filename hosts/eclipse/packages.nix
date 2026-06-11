{ pkgs, inputs, ... }:
{
  programs.appimage.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ ];
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    # Desktop
    niri
    ghostty
    yazi
    opencode
    steam
    gamescope
    mangohud
    xwayland
    xwayland-satellite
    vesktop
    pavucontrol
    mpv
    
    # CLI tools
    btop
    git
    p7zip
    superfile
    helix
    micro
    neovim
    lazygit

    wtype
    jq

    # ASUS
    asusctl
    supergfxctl

    # Power
    auto-cpufreq

    dotnet-runtime_10
    webkitgtk_4_1
    unzip
    rpm

    # Custom
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
