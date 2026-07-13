{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./system.nix
    ./vfio.nix
    ./users.nix
    ./packages.nix
  ];
}
