{
  pkgs,
  nvidia ? false,
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

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Nix helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 2w --keep 3";
    };
    flake = "/nixos-config";
  };

  # pam service
  security.pam.services = {
    sudo.nodelay = true;
    gtklock = {
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

  # Early OOM to prevent hang
  services.earlyoom.enable = true;

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
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # NPM
  programs.npm = {
    enable = true;
  };

  # Localsend
  programs.localsend = {
    enable = true;
    openFirewall = true;
  };

  environment.localBinInPath = true;

  # env
  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    NIXOS_OZONE_WL = 1;
    MOA_ENABLE_WAYLAND = 1;
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_STYLE_OVERRIDE = "kvantum";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";
    CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4";
    XCOMPOSEFILE = "~/.XCompose";
    GDK_SCALE = "2";
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gcr/ssh";
    GNOME_KEYRING_CONTROL = "\${XDG_RUNTIME_DIR}/keyring";

    # templates = "${self}/dev-shells";
  }
  // (
    if nvidia then
      {
        NVD_BACKEND = "direct";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";

        # fix vulkan on nvidia
        GSK_RENDERER = "ngl";
      }
    else
      { }
  );

  environment.systemPackages =
    with pkgs;
    [
      killall
      libsecret
      upower
      libnotify
      neofetch
      inetutils
      dnsutils
      xray
      wl-clipboard
      podman-compose
      nnd
      vulkan-tools # For vkcube, vulkaninfo
      vulkan-loader
      vulkan-validation-layers
    ]
    ++ (
      if nvidia then
        [
          egl-wayland
          (pkgs.ollama.override {
            acceleration = "cuda";
          })
        ]
      else
        [ ]
    );

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

    kernel.sysctl = {
      "kernel.yama.ptrace_scope" = 0;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
