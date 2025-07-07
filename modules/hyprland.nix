{
  pkgs,
  ...
}:
{
  environment.systemPackages = [pkgs.kitty];

  programs.hyprland.enable = true;

  # Setup keyring
  services.gnome.gnome-keyring.enable = true;

}
