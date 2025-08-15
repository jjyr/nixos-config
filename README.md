# NixOS config

NixOS + Niri

## Usage

``` bash
# After initial setup
nixos-rebuild switch --flake /nixos-config#<machine>

# You can run the following command to rebuild OS
nh os switch
```

## Shortcuts

[Shortcut keys](./modules/config-hyprland.nix)

## Develop Environment

``` bash
# Use a pre-defined develop environment
use_env rust

# The command is equals to
nix develop --impure /nixos-config/devenvs/#rust
```

See [devenvs/flake.nix](./devenvs/flake.nix) to learn more.

[omarchy]: https://github.com/basecamp/omarchy

