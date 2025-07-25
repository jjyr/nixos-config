{ inputs, pkgs, ... }:
{
  networking.hostName = "laptop";

  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ../common.nix
  ];

  _module.args.extraKernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "amdgpu" ];
  environment.systemPackages = with pkgs; [ rocmPackages.amdsmi ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
      # vulkan-loader
      # vulkan-extension-layer
      # vulkan-validation-layers
    ];
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  # allowUnfree
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
