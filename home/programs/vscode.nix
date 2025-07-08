{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        golang.go
        eamodio.gitlens
        vadimcn.vscode-lldb
        vscodevim.vim
      ];
      enableUpdateCheck = true;

      userSettings = {
        editor = {
          formatOnSave = true;
        };
        debug = {
          allowBreakpointsEverywhere = true;
        };
        nix = {
          enableLanguageServer = true;
          serverPath = "nil";
          serverSettings = {
            nil = {
              diagnostics = {
                ignored = [
                  "unused_binding"
                  "unused_with"
                  "unused_rec"
                ];
              };
              formatting = {
                command = [ "nixpkgs-fmt" ];
              };
            };
          };
        };
        keyboard = {
          dispatch = "keyCode";
        };
        vim = {
          useSystemClipboard = true;
        };
      };
    };
  };
}
