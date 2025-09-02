{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.eza
    pkgs.bat
  ];

  programs.fzf.enable = true;
  programs.zsh.enable = true;
  programs.zsh.initContent =
    let
      zshConfig = lib.mkOrder 1500 ''
        export PATH=$PATH:/usr/local/sbin:/opt/homebrew/bin:~/go/bin:~/.cargo/bin:~/.local/bin:~/.npm/bin

        # PROMPT
        autoload -Uz vcs_info
        precmd() { vcs_info }
        zstyle ':vcs_info:git:*' formats '(%b)'
        setopt PROMPT_SUBST
        PROMPT='%B%F{green}%n@%m:%B%F{cray}%~%f%F{yellow}''${vcs_info_msg_0_}%f%B%F{cray}$ %f%b'

        use_dev() {
          if [[ -z "$1" ]]; then
            echo "❌ Please pass dev env arg, for example: use_dev rust"
            echo "Usage: use_dev <name>"
            return 1
          fi
          nix develop --impure ~/Workspace/nixos-config/devenvs#"$1"
        }

        # edit-command-line
        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey "^x^E" edit-command-line
      '';
    in
    lib.mkMerge [
      zshConfig
    ];

  programs.zsh.profileExtra = ''
    # zellij
    eval "$(zellij setup --generate-auto-start zsh)"
  '';
  programs.zsh.shellAliases = {
    ls = "eza";
    cat = "bat";
    lg = "lazygit";
  };
}
