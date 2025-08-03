{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    colorSchemes = {
      myTheme = {
        ansi = [
          "#32344a"
          "#f7768e"
          "#9ece6a"
          "#e0af68"
          "#7aa2f7"
          "#ad8ee6"
          "#449dab"
          "#787c99"
        ];
        brights = [

          "#444b6a"
          "#ff7a93"
          "#b9f27c"
          "#ff9e64"
          "#7da6ff"
          "#bb9af7"
          "#0db9d7"
          "#acb0d0"
        ];

        background = "#1a1b26";
        foreground = "#a9b1d6";
        selection_fg = "#7aa2f7";
      };
    };

    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()
      config.font = wezterm.font("CaskaydiaMono Nerd Font")
      config.font_size = 9.0
      config.color_scheme = "myTheme"
      config.hide_tab_bar_if_only_one_tab = true
      config.ssh_domains = {
        {
          name = 'homepc',
          remote_address = '100.88.102.13',
          username = 'jjy',
        }
      }
      return config
    '';
  };
}
