{
  pkgs,
  lib,
  inputs,
  ...
}: let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in{
  environment.systemPackages = [pkgs.kitty];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

  };

# avoid mesa version mismatch
  hardware.graphics = {
    package = pkgs-unstable.mesa;
    # if you also want 32-bit support (e.g for Steam)
    # enable32Bit = true;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa;
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
