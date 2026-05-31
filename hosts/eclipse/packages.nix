{ pkgs, inputs, ... }:
{
  programs.appimage.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      niri = prev.niri.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/bin/niri-session \
            --replace-fail 'systemctl --user import-environment' \
                           'systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET'
        '';
      });
    })
  ];
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
    inputs.noctalia.packages.${pkgs.system}.default
    inputs.helium.packages.${pkgs.system}.default
  ];
}
