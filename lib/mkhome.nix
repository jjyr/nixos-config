{
  nixpkgs,
  inputs,
}:

{
  system,
  nvidia ? false,
}:
let
  nixospkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
in

inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};

  extraSpecialArgs = {
    pkgs = nixospkgs;
    inherit inputs;
    inherit nvidia;
  };

  modules = [
    { nixpkgs.config.allowUnfree = true; }
    ../home/users/jjy/home.nix
  ];
}
