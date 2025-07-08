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
    XDG_DATA_DIRS ="${home.homeDirectory}/.local/share:${home.homeDirectory}/.nix-profile/share";
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
    ../../programs/wofi.nix

    # services
    ../../services/hypridle.nix
    ../../services/hyprpaper.nix
    ../../../modules/config-hyprland.nix
  ];

  services.ssh-agent.enable = true;

# Cursor theme
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.file = {

# Default wallpaper
    "./.config/wallpaper/default.jpg".source = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1651870364199-fc5f9f46ac85";
      sha256 = "sha256-mjb4rifSKu34xisxSn9LY5JwhW0Ktf8BIM0aV08QYFg=";
      name = "default.jpg";
    };
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
