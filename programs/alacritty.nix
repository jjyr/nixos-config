{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        term = "xterm256color";
      };

      general = {
        import = [
          "~/.config/alacritty/omarchy.toml"
        ];
      };

      font = {
        size = 9;
        normal = {
          family = "Caskaydi a Mono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "Caskaydi a Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "Caskaydi a Mono Nerd Font";
          style = "Italic";
        };
      };

      window = {
          padding = {x = 14; y = 14;};
          opacity = 0.98;
        };
    };
  };

  # Omarchy default theme
  home.file = {
    "./.config/alacritty/omarchy.toml".text = /*toml*/ ''
    [colors]
    [colors.primary]
    background = '#1a1b26'
    foreground = '#a9b1d6'
    
    # Normal colors
    [colors.normal]
    black = '#32344a'
    red = '#f7768e'
    green = '#9ece6a'
    yellow = '#e0af68'
    blue = '#7aa2f7'
    magenta = '#ad8ee6'
    cyan = '#449dab'
    white = '#787c99'
    
    # Bright colors
    [colors.bright]
    black = '#444b6a'
    red = '#ff7a93'
    green = '#b9f27c'
    yellow = '#ff9e64'
    blue = '#7da6ff'
    magenta = '#bb9af7'
    cyan = '#0db9d7'
    white = '#acb0d0'
    
    [colors.selection]
    background = '#7aa2f7'
    '';
  };
}
