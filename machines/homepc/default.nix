{ config, pkgs, ... }:
{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ../common.nix
  ];

  _module.args = {
    extraKernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];
    nvidia = true;
  };

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
  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
  };

  # networking
  networking.interfaces.enp42s0.ipv4.routes = [
    {
      address = "100.64.0.0";
      prefixLength = 10;
      via = "192.168.50.1";
    }
  ];

  # niri https://github.com/YaLTeR/niri/wiki/Nvidia
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
    ''
      {
          "rules": [
              {
                  "pattern": {
                      "feature": "procname",
                      "matches": "niri"
                  },
                  "profile": "Limit Free Buffer Pool On Wayland Compositors"
              }
          ],
          "profiles": [
              {
                  "name": "Limit Free Buffer Pool On Wayland Compositors",
                  "settings": [
                      {
                          "key": "GLVidHeapReuseRatio",
                          "value": 0
                      }
                  ]
              }
          ]
      }
    '';

  # Ollama
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
