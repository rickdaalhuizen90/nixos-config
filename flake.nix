{
  description = "Rick's NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... } @ inputs: {
    templates = {
      phoenix = {
        path = ./templates/phoenix;
        description = "A development environment for an Elixir/Phoenix project";
      };
      symfony = {
        path = ./templates/symfony;
        description = "A development environment for a PHP/Symfony project";
      };
      java = {
        path = ./templates/java;
        description = "A development environment for a Java project";
      };
    };
    homeConfigurations = {
      "rick" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home/rick.nix
        ];
      };
    };
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          username = "rick";
        };

        modules = [
          ./configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              username = "rick";
            };
            home-manager.users.rick = {
              imports = [
                sops-nix.homeManagerModules.sops
                ./home.nix
              ];
            };
          }
        ];
      };
    };
  };
}
