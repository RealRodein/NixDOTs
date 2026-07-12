{ pkgs, inputs, ... }:
{
  programs.appimage.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];

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

    # File manager
    thunar
    thunar-volman
    tumbler
    file-roller

    # Editor
    zed-editor

    # CLI tools
    btop
    git
    p7zip
    neovim
    lazygit

    wtype
    jq

    appimage-run
    dotnet-runtime_10
    unzip
    rpm

    # Custom
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
