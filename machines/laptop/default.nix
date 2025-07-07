{inputs, pkgs, ...}: {
  imports = [
    ../../disko-config.nix
    ./hardware-configuration.nix
  ];
  services.xserver = {
    enable = true;
    xkb = {layout = "us";};
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05"; # Did you read the comment?
}
