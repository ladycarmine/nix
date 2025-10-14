{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations = {

      "workstation" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; 

        modules = [
          ./modules/hostname/quasar.nix
          ./modules/common/module.nix
          ./modules/common-ui/module.nix
          ./modules/hardware/hardware-configuration.nix
          ./modules/plasma-desktop/module.nix
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

    };

  };
}