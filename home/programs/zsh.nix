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
  programs.zsh.envExtra = ''
    export PATH=$PATH:~/go/bin:~/.cargo/bin:~/.local/bin:~/.npm/bin
    parse_git_branch() {
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[(\1)\]/'
    }
    export PS1="\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\[\033[33m\]\$(parse_git_branch)\[\033[1;32m\]\$\[\033[0m\] "

    use_dev() {
      if [[ -z "$1" ]]; then
        echo "❌ Please pass dev env arg, for example: use_dev rust"
        echo "Usage: use_dev <name>"
        return 1
      fi
      nix develop --impure /nixos-config/devenvs#"$1"
    }
  '';

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
