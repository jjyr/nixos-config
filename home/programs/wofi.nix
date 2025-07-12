{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.wofi = {
    enable = true;
  };

  # Wofi
  home.file = {
    "./.config/wofi/config".text = # toml
      ''
        width=600
        height=350
        location=center
        show=drun
        prompt=Search...
        filter_rate=100
        allow_markup=true
        no_actions=true
        halign=fill
        orientation=vertical
        content_halign=fill
        insensitive=true
        allow_images=true
        image_size=40
        gtk_dark=true
      '';

    "./.config/wofi/style.css".text = ''
      @define-color	selected-text  #7dcfff;
      @define-color	text  #cfc9c2;
      @define-color	base  #1a1b26;
      @define-color	border  #33ccff;
    '';

    "./.config/wofi/select.css".text = ''
      @import ".config/wofi/style.css";
      @import ".local/wofi/style.css";

      #input {
          display: none;
          opacity: 0;
          margin-top: -200px;
      }
    '';

    "./.config/wofi/search.css".text = ''
      @import ".config/wofi/style.css";

      * {
        font-family: 'CaskaydiaMono Nerd Font', monospace;
        font-size: 18px;
      }

      window {
        margin: 0px;
        padding: 20px;
        background-color: @base;
        opacity: 0.95;
      }

      #inner-box {
        margin: 0;
        padding: 0;
        border: none;
        background-color: @base;
      }

      #outer-box {
        margin: 0;
        padding: 20px;
        border: none;
        background-color: @base;
        border: 2px solid @border;
      }

      #scroll {
        margin: 0;
        padding: 0;
        border: none;
        background-color: @base;
      }

      #input {
        margin: 0;
        padding: 10px;
        border: none;
        background-color: @base;
        color: @text;
      }

      #input:focus {
        outline: none;
        box-shadow: none;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: @text;
      }

      #entry {
        background-color: @base;
      }

      #entry:selected {
        outline: none;
        border: none;
      }

      #entry:selected #text {
        color: @selected-text;
      }

      #entry image {
        -gtk-icon-transform: scale(0.7);
      }
    '';
  };

}
