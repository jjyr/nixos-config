# home.nix
{ pkgs, inputs, nvidia, preventlock, ... }:
rec {
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
  home.username = "jjy";
  home.homeDirectory = "/home/jjy";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
    DISPLAY = ":0";
  };

  xdg.enable = true;
  xdg.portal = {
    enable = true;
    config = {
      common = {
          default = ["hyprland"];
      };
      hyprland = {
          default = ["gtk" "hyprland"];
      };
    };

    xdgOpenUsePortal = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [
        "firefox.desktop"
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/http " = [
        " firefox.desktop"
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/https" = [
        "firefox.desktop"
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/about" = [
        "firefox.desktop"
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/unknown" = [
        "firefox.desktop"
        "chromium-browser.desktop"
      ];
    };
  };


  home.packages = with pkgs; [

    # tools
    tailscale
    vlc
    obsidian
    btop
    nixfmt-rfc-style
  ];

  # Programs
  imports = [
    # ime
    ../../i18n.nix
    # programs
    ../../programs/alacritty.nix
    ../../programs/bash.nix
    ../../programs/direnv.nix
    ../../programs/chromium.nix
    ../../programs/fonts.nix
    ../../programs/git.nix
    ../../programs/neovim
    ../../programs/vscode.nix
    ../../programs/hyprlock.nix
    ../../programs/waybar.nix

    # services
    ../../services/hypridle.nix
    ../../../modules/config-hyprland.nix
  ];


  # Wofi
  home.file = {
    "./.config/wofi/config".text = /*toml*/ ''
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


  # # secrets
  # age = {
  #   identityPaths = [ "${home.homeDirectory}/.ssh/id_ed25519.age" ];
  #   secrets = {
  #     git-credentials = {
  #       file = ./secrets/git-credentials.age;
  #       path = "${home.homeDirectory}/.git-credentials";
  #       mode = "600";
  #     };
  #   };
  # };

}
