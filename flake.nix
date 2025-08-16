{
  description = "A simple flake by jjy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:

    let
      mkSystem = import ./lib/mksystem.nix {
        inherit inputs;
        inherit nixpkgs;
      };

      mkHome = import ./lib/mkhome.nix {
        inherit inputs;
        inherit nixpkgs;
      };
    in
    {
      nixosConfigurations = {
        laptop = mkSystem {
          name = "laptop";
          system = "x86_64-linux";
        };

        homepc = mkSystem {
          name = "homepc";
          system = "x86_64-linux";
          nvidia = true;
        };
      };

      darwinConfigurations = {
        devmac = mkSystem {
          name = "devmac";
          system = "aarch64-darwin";
          darwin = true;
        };
      };

      homeConfigurations = {
        "jjy@laptop" = mkHome {
          system = "x86_64-linux";
        };

        "jjy@homepc" = mkHome {
          system = "x86_64-linux";
          nvidia = true;
        };
      };
    };
}
