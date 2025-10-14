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

      # The workstation configuration contains almost all modules,
      # designed for a general-purpose, powerful desktop computer
      "workstation" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; 

        modules = [
          ./modules/hostname/quasar.nix
          ./modules/art/module.nix
          ./modules/common/module.nix
          ./modules/common-ui/module.nix
          ./modules/dev/module.nix
          ./modules/gaming/module.nix
          ./modules/hardware/hardware-configuration.nix
          ./modules/media/module.nix
          ./modules/office/module.nix
          ./modules/plasma-desktop/module.nix
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

    };

  };
}