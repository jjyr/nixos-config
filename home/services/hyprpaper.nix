{
  config,
  pkgs,
  home,
  ...
}:

{
  home.packages = with pkgs; [
    hyprpaper
  ];
  # config wallpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "~/.config/wallpaper/default.jpg";
      wallpaper = ",~/.config/wallpaper/default.jpg";
    };
  };
}
