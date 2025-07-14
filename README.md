# NixOS config

Hyprland + NixOS

Inspired by DHH's [Omarchy][omarchy] setup, and more.

## Shortcuts

[Shortcuts](./modules/config-hyprland.nix)

## Develop Environment

``` bash
# Use a pre-defined develop environment
use_env rust

# The command is equals to
nix develop --impure /nixos-config/devenvs/#rust
```

See [devenvs/flake.nix](./devenvs/flake.nix) to learn more.

[omarchy]: https://github.com/basecamp/omarchy

