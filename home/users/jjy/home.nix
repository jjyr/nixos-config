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
  };

  xdg.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
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
