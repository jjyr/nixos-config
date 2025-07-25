{
  config,
  pkgs,
  home,
  ...
}:

{
  services.mako = {
    enable = true;
    settings = {
      text-color = "#a9b1d6";
      border-color = "#33ccff";
      background-color = "#1a1b26";
      width = 420;
      height = 110;
      padding = 10;
      border-size = 2;
      font = "Liberation Sans 11";
      anchor = "top-right";
      default-timeout = 5000;
      max-icon-size = 32;

      "app-name=Spotify" = {
        invisible = 1;
      };

      "mode=do-not-disturb" = {
        invisible = true;
      };

      "mode=do-not-disturb app-name=notify-send" = {
        invisible = false;
      };
    };
  };
}
