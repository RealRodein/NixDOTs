{ ... }:

{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "pnpm-10.29.2" ];
}
