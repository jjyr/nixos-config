{ inputs, pkgs, ... }:
{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ../common.nix
  ];

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzqqIUmjCCZSh6+5xYBtTMQpK1FSA36IHTaWC6qt+jG"
  ];

  # nvidia
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia.open = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05"; # Did you read the comment?
}
