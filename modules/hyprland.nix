{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    wireplumber
    playerctl
    blueberry
    pavucontrol
    pamixer
    hyprcursor
    hyprpolkitagent
    hyprshot
    #notification
    mako
    # clipboard
    wl-clip-persist
    clipse
    # to fix some features such as open link or folder
    xdg-utils
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    config = {
      common = {
        default = "gtk";
      };
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];

  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    # package = pkgs.hyprland;
    # portalPackage =
    #  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # avoid mesa version mismatch
  hardware.graphics = {
    package = pkgs.mesa;
    # if you also want 32-bit support (e.g for Steam)
    # enable32Bit = true;
    # package32 = pkgs.pkgsi686Linux.mesa;
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
          session = "${pkgs.hyprland}/bin/Hyprland";
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
