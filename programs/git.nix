{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tig
  ];

  programs.git = {
    enable = true;
    userName = "jjy";
    userEmail = "jjyruby@gmail.com";
    ignores = [
      ".direnv/"
      ".go/"
    ];
    extraConfig = {
      init = { defaultBranch = "main"; };
      pull = { rebase = true; };
      push = { autoSetupRemote = true; };
      merge = { conflictstyle = "diff3"; };
      # timeout after 90 days
      credential.helper = "cache --timeout=7776000";
    };
  };
}
