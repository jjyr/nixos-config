# home.nix
{ pkgs, ... }: rec {
  home.stateVersion = "25.05";
  home.username = "jjy";
  home.homeDirectory = "/home/jjy";

  home.sessionVariables = {
    EDITOR = "nvim";
    NIX_PATH = "nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" "chromium-browser.desktop" ];
      "x-scheme-handler/http " = [ " firefox.desktop" "chromium-browser.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" "chromium-browser.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" "chromium-browser.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" "chromium-browser.desktop" ];
    };
  };

  home.packages = with pkgs; [
# input method
    fcitx5-chinese-addons
      fcitx5-hangul
      fcitx5-configtool

# tools
      tailscale
      vlc
      obsidian
      btop
  ];

# Programs
  imports = [
    ../../programs/alacritty.nix
      ../../programs/bash.nix
      ../../programs/direnv.nix
      ../../programs/chromium.nix
      ../../programs/fonts.nix
      ../../programs/git.nix
      ../../programs/neovim
      ../../programs/vscode.nix
  ];

# secrets
  age = {
    identityPaths = [ "${home.homeDirectory}/.ssh/id_ed25519.age" ];
    secrets = {
      git-credentials = {
        file = ./secrets/git-credentials.age;
        path = "${home.homeDirectory}/.git-credentials";
        mode = "600";
      };
    };
  };

  programs.home-manager.enable = true;

}
