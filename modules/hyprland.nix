{
  pkgs,
  ...
}:
{
  environment.systemPackages = [pkgs.kitty];

  programs.hyprland.enable = true;
}
