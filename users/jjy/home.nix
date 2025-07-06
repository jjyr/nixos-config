# home.nix
{ pkgs, ... }: {
  home.stateVersion = "25.05";
  home.username = "jjy";
  home.homeDirectory = "/home/jjy";
  home.packages = with pkgs; [
      tailscale

      # input method
      fcitx5-chinese-addons
      fcitx5-hangul
      fcitx5-configtool
  ];
  home.file.".bashrc".source = ./dotfiles/bashrc;

# # secrets
#   age.secrets.git-credentials = {
#     file = ./secrets/git-credentials.age;
#     path = "${config.home.homeDirectory}/.git-credentials";
#     mode = "600";
#   };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    extraConfig = {
      init = { defaultBranch = "master"; };
      user = { name = "jjy"; email = "jjyruby@gmail.com"; };
# timeout after 90 days
      credential.helper = "cache --timeout=7776000";
    };
  };
}
