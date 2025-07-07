{
  pkgs,
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

  hardware.graphics = {
    package = pkgs-unstable.mesa;
    # if you also want 32-bit support (e.g for Steam)
    # enable32Bit = true;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa;
  };

  # Setup keyring
  services.gnome.gnome-keyring.enable = true;

}
