{ nixpkgs, home-manager, lsfg-vk, inputs }:

{ system, hostPath }:
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = { inherit inputs; };

  modules = [
    hostPath

    home-manager.nixosModules.home-manager
    lsfg-vk.nixosModules.default

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs;
          machineName = nixpkgs.lib.last (nixpkgs.lib.splitString "/" (toString hostPath));
        };

        users.rodein = import ../home/rodein.nix;
      };
    }
  ];
}
