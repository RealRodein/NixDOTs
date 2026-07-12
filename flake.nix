{
  description = "NixDOTs system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia-shell/main";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    mkHost = hostPath: nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        hostPath

        home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = {
              inherit inputs;
              machineName = nixpkgs.lib.last (nixpkgs.lib.splitString "/" (toString hostPath));
            };

            users.rodein = import ./home/rodein.nix;
          };
        }
      ];
    };
  in {
    nixosConfigurations.orbiter = mkHost ./hosts/orbiter;
    nixosConfigurations.railjack = mkHost ./hosts/railjack;
  };
}
