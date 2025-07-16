{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        golang.go
        eamodio.gitlens
        vadimcn.vscode-lldb
        vscodevim.vim
      ];
      enableUpdateCheck = true;
    };
  };
}
