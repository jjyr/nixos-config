{
  nixpkgs,
  inputs,
}:

{
  system,
  nvidia ? false,
}:

inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.${system};

  extraSpecialArgs = {
    inherit inputs;
    inherit nvidia;
  };

  modules = [
    { nixpkgs.config.allowUnfree = true; }
    ../home/users/jjy/home.nix
  ];
}
