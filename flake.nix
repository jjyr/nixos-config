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

    waybar = {
      url = "github:Alexays/waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
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
      system = "x86_64-linux";
      sharedModules = [
        agenix.nixosModules.default
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        ./modules/user.nix
        ./modules/network.nix
        ./modules/hyprland.nix
        ({pkgs, config, ...}: {
          config = {
            nix.settings = {
              # add binary caches
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
              ];
              substituters = [
                "https://cache.nixos.org"
                "https://nixpkgs-wayland.cachix.org"
              ];
            };

            # use it as an overlay
            nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

            # # or, pull specific packages (built against inputs.nixpkgs, usually `nixos-unstable`)
            # environment.systemPackages = [
            #   inputs.nixpkgs-wayland.packages.${system}.waybar
            # ];
          };
        })
      ];
      homeModules = [
        agenix.homeManagerModules.default
        ./users/jjy/home.nix
      ];

      nixospkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {allowUnfree = true;};
      };

      x86pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {allowUnfree = true;};
      };
    in
    {

      # Enable Cachix for hyprland
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = sharedModules ++ [
            ./machines/laptop/default.nix
            {
              home-manager.extraSpecialArgs = {pkgs=nixospkgs; nvidia = false; preventlock = false; inherit inputs;};
              home-manager.users.jjy = ./home/users/jjy/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };

        homepc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = sharedModules ++ [
            ./machines/homepc/default.nix
            # ({pkgs, ...}: {
	    #   users.users.jjy.isNormalUser = true;
            #   home-manager.users.jjy = import ./home/users/jjy/home.nix {nvidia = false; preventlock = false; inherit pkgs;};
            #   home-manager.backupFileExtension = "backup";
            # })
          ];
        };
      };

      homeConfigurations = {
        "jjy@laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = x86pkgs;
          extraSpecialArgs = {
            inherit inputs;
            nvidia = false;
            preventlock = false;
          };
          modules = homeModules;
        };

        "jjy@homepc" = home-manager.lib.homeManagerConfiguration {
          pkgs = x86pkgs;
          extraSpecialArgs = {
            inherit inputs;
            nvidia = true;
            preventlock = true;
          };
          modules = homeModules;
        };
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
