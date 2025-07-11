{ inputs, pkgs, ... }:
{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking.hostName = "homepc";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  users.users.jjy.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINzqqIUmjCCZSh6+5xYBtTMQpK1FSA36IHTaWC6qt+jG"
  ];

  # nvidia
  environment.systemPackages = with pkgs; [
    egl-wayland
  ];
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    open = true;
    nvidiaSettings = true;
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # networking
  networking.interfaces.enp42s0.ipv4.routes = [
    {
      address = "100.64.0.0";
      prefixLength = 10;
      via = "192.168.50.1";
    }
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
