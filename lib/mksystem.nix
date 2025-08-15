{
  nixpkgs,
  inputs,
}:

{
  name,
  system,
  nvidia ? false,
  darwin ? false,
}:

let
  machineConfig = ../machines/${name}/default.nix;
  nixospkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };

  isLinux = !darwin;

  waylandCache = (
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
  );

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;

in
systemFunc {
  inherit system;
  specialArgs = {
    inherit inputs;
  };

  modules =
    (nixpkgs.lib.optionals isLinux [
      waylandCache
      inputs.disko.nixosModules.disko
      ../modules/network.nix
      #../modules/hyprland.nix
      ../modules/niri.nix
      ../modules/xwayland-satellite.nix
      ../modules/user.nix
    ])
    ++ (nixpkgs.lib.optionals darwin [
      ../modules/darwin-user.nix
    ])
    ++ [
      # inputs.agenix.nixosModules.default
      # Home manager
      home-manager.home-manager
      {

        home-manager.extraSpecialArgs = {
          pkgs = nixospkgs;
          inherit nvidia;
          inherit inputs;
        };
        home-manager.users.jjy = ../home/users/jjy/home.nix;
        home-manager.backupFileExtension = "backup";
      }
      ../modules/nix-options.nix
      machineConfig

    ];
}
