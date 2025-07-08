{inputs, pkgs, ...}: {
  imports = [../../disko-config.nix];
  services.xserver = {
    enable = true;
  };
}

