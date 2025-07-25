# home.nix
{
  pkgs,
  inputs,
  nvidia,
  ...
}:
rec {
  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
  home.username = "jjy";
  home.homeDirectory = "/home/jjy";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
    DISPLAY = ":0";
    XDG_DATA_DIRS = "${home.homeDirectory}/.local/share:${home.homeDirectory}/.nix-profile/share:/run/current-system/sw/share";
    XDG_PICTURES_DIR = "${home.homeDirectory}/Downloads";
    HYPRSHOT_DIR = "${home.homeDirectory}/Downloads";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = [
        "imv.desktop"
      ];
      "image/jpeg" = [
        "imv.desktop"
      ];
      "image/gif" = [
        "imv.desktop"
      ];
      "image/webp" = [
        "imv.desktop"
      ];
      "image/bmp" = [
        "imv.desktop"
      ];
      "image/tiff" = [
        "imv.desktop"
      ];

      "video/mp4" = [
        "mpv.desktop"
      ];
      "video/x-msvideo" = [
        "mpv.desktop"
      ];
      "video/x-matroska" = [
        "mpv.desktop"
      ];
      "video/x-flv" = [
        "mpv.desktop"
      ];
      "video/x-ms-wmv" = [
        "mpv.desktop"
      ];
      "video/mpeg" = [
        "mpv.desktop"
      ];
      "video/ogg" = [
        "mpv.desktop"
      ];
      "video/webm" = [
        "mpv.desktop"
      ];
      "video/quicktime" = [
        "mpv.desktop"
      ];
      "video/3gpp" = [
        "mpv.desktop"
      ];
      "video/x-ms-asf" = [
        "mpv.desktop"
      ];
      "video/x-ogm+ogg" = [
        "mpv.desktop"
      ];
      "video/x-theora+ogg" = [
        "mpv.desktop"
      ];
      "application/ogg" = [
        "mpv.desktop"
      ];

      "inode/directory" = [
        "nautilus.desktop"
      ];

      "text/html" = [
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/http " = [
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/https" = [
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/about" = [
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/unknown" = [
        "chromium-browser.desktop"
      ];
    };
  };

  home.packages = with pkgs; [

    # tools
    tailscale
    mpv
    obsidian
    btop
    nixfmt-rfc-style
    imv
    sushi
    nautilus
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
    ../../services/mako.nix

    # config hyprland
    ../../../modules/config-hyprland.nix
  ];

  services.ssh-agent.enable = true;

  # battery notify
  services.poweralertd.enable = true;

  # Cursor theme
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
  };

  home.file = {

    # Default wallpaper
    "./.config/wallpaper/default.jpg".source = pkgs.fetchurl {
      url = "https://unsplash.com/photos/kk3W5-0b6e0/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzUyMzMzNTU0fA";
      sha256 = "sha256-Y4uZavbwhsqfQxIxsy7CbFQTqxDfNVxTqpzrBH6EGl8=";
      name = "default.jpg";
    };

    # ssh
    "./.ssh/config".text = ''
      Host homepc
      HostName homepc
      User jjy
      ForwardAgent yes
    '';

    # scripts
    "./.local/bin/show-power-menu".source = ./scripts/show-power-menu;
  };
}
