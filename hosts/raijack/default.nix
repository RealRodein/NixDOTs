{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./system.nix
    ./users.nix
    ./packages.nix
  ];
}
