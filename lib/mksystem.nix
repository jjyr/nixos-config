{
  nixpkgs,
  inputs,
}:

{
  name,
  system,
  nvidia ? false,
}:

let
  machineConfig = ../machines/${name}/default.nix;
  nixospkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

in
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs;
  };

  modules = [
    (
      { pkgs, config, ... }:
      {
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
        };
      }
    )
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../modules/user.nix
    ../modules/network.nix
    ../modules/hyprland.nix
    ../modules/nix-options.nix

    machineConfig

    # Home manager
    {
      home-manager.extraSpecialArgs = {
        pkgs = nixospkgs;
        inherit nvidia;
        inherit inputs;
      };
      home-manager.users.jjy = ../home/users/jjy/home.nix;
      home-manager.backupFileExtension = "backup";
    }
  ];
}
