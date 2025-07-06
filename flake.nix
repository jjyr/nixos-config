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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      disko,
      ...
    }@inputs:

    let
      sharedModules = [
        agenix.nixosModules.default
        disko.nixosModules.disko
      ];
      homeModules = [
        agenix.homeManagerModules.default
          ./modules/hyprland.nix
          ./users/jjy/home.nix
      ];
    in
    {

      # Enable Cachix for hyprland
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      nixosConfigurations.devpc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          ./machines/devpc/default.nix
        ];
      };

      homeConfigurations."jjy@devpc" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
          nvidia = false;
          preventlock = false;
        };
        modules = homeModules;
      };

      homeConfigurations."jjy@homepc" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
          nvidia = true;
          preventlock = true;
        };
        modules = homeModules;
      };

      systemd.user.services."ssh-agent" = {
        enable = true;
        description = "SSH key agent";
        serviceConfig = {
          Type = "simple";
          ExecStart = "/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
        };
        environment = {
          SSH_AUTH_SOCK = "%t/ssh-agent.socket";
          DISPLAY = ":0";
        };
        wantedBy = "default.target";
      };
    };
}
