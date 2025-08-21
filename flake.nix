{
  description = "A working NixOS 25.05 configuration with Neovim Nightly";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, neovim-nightly, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; username = "rick"; };
        modules = [
          ({ nixpkgs.overlays = [ neovim-nightly.overlays.default ]; })

          ({ ... }:
            let
              unstablePkgs = import nixpkgs-unstable {
                system = "x86_64-linux";
                config = { allowUnfree = true; };
              };
            in {
              nixpkgs.overlays = [
                (final: prev: {
                  aider-chat = unstablePkgs.aider-chat;
                })
              ];
            }
          )

          ./configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          ({
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; username = "rick"; };
            home-manager.users.rick = {
              imports = [
                sops-nix.homeManagerModules.sops
                ./home.nix
              ];
            };
          })
        ];
      };
    };
  };
}

