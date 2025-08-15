{
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    niri
    brightnessctl
    wireplumber
    playerctl
    blueberry
    pavucontrol
    pamixer
    #notification
    mako
    # clipboard
    wl-clip-persist
    clipse
    # to fix some features such as open link or folder
    xdg-utils
    fuzzel
    swayidle
    swaylock

    xwayland-satellite
  ];

  programs = {
    xwayland.enable = true;
    niri = {
      enable = true;
      # package = pkgs.niri-unstable;
    };
    gtklock.enable = true;
  };

  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";

  services = {
    xserver.desktopManager.runXdgAutostartIfNone = true;
    # gvfs.enable = true;
    # seatd.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      config = {
        niri = {
          default = [ "gnome" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [
          "Alacritty.desktop"
        ];
      };
    };
    autostart.enable = true;
  };

  # Enable greetd
  services.greetd = {
    enable = true;
    settings = rec {
      regreet_session = {
        command = "${lib.getExe pkgs.cage} -s -- ${lib.getExe pkgs.greetd.regreet}";
        user = "greeter";
      };
      tuigreet_session =
        let
          session = "${pkgs.niri}/bin/niri-session";
          tuigreet = "${lib.getExe pkgs.greetd.tuigreet}";
        in
        {
          command = "${tuigreet} --time --remember --cmd ${session}";
          user = "greeter";
        };
      default_session = tuigreet_session;
    };
  };

  # tty service config
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
