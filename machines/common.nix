{
  pkgs,
  extraKernelModules ? [ ],
  ...
}:
{
  time.timeZone = "Asia/Shanghai";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          bluetooth.autoswitch-to-headset-profile = false
        '')
      ];
    };
  };

  services.xserver.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # power profile
  services.power-profiles-daemon.enable = true;

  # Enable tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # firewall
  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
  };
  networking.nftables.enable = true;

  # keyring
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [
    libsecret
    gcr_4
  ];
  programs.gnupg = {
    dirmngr.enable = true;
    agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";
  environment.localBinInPath = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Nix helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 2w --keep 3";
    };
    flake = "/home/jjy/nixos-config";
  };

  # pam service
  security.pam.services = {
    sudo.nodelay = true;
    hyprlock = {
      nodelay = true;
      enableGnomeKeyring = true;
    };
    greetd.enableGnomeKeyring = true;
  };

  services.upower.enable = true;

  # proxy tool
  services.v2raya = {
    enable = true;
    cliPackage = pkgs.xray;
  };

  # blue tooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Steam
  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = true;
    };
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # env
  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    NIXOS_OZONE_WL = 1;
    MOA_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";

    # templates = "${self}/dev-shells";
  };

  environment.systemPackages = with pkgs; [
    gcc
    killall
    libsecret
    upower
    libnotify
    neofetch
    inetutils
    xray
  ];

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # common boot setup
  boot = {
    initrd.kernelModules = [ "nft_tproxy" ] ++ extraKernelModules;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
