{ pkgs, inputs, ... }:
{
  programs.appimage.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];

  nixpkgs.overlays = [
    (final: prev: {
      opencode = prev.opencode.overrideAttrs (old: {
        version = "1.17.18";
        src = final.fetchFromGitHub {
          owner = "anomalyco";
          repo = "opencode";
          tag = "v1.17.18";
          hash = "sha256-Y0rcO6r9yqhYux8IS5oAtgzcMXfJE8I1Lre4HdJ5nBg=";
        };
        node_modules = old.node_modules.overrideAttrs (_: {
          outputHash = "sha256-kXdXw264JQdlNoZPv5GUyWZvb/A8h2CTRdiX79jyvys=";
        });
      });
    })
  ];
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    # Desktop
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
    mpvpaper

    # File manager
    nemo

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

    # VM / VFIO
    looking-glass-client
    swtpm
    virt-viewer

    # Custom
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
