{ pkgs, ... }:

{
  users.users.rodein = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
  };
}
