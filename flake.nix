{
  description = "A simple flake by jjy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix }@inputs: 

    let
    sharedModules = [
    agenix.nixosModules.default
    ];
  in {

    nixosConfigurations.devpc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = sharedModules ++
        [
        ./machines/devpc/default.nix
        ];
    };

    homeConfigurations."jjy" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      modules = [
        agenix.homeManagerModules.default
          ./users/jjy/home.nix
      ];
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-hangul
      ];
    };

    systemd.user.services."ssh-agent" = {
      enable = true;
      description = "SSH key agent";
      serviceConfig = {
        Type = "simple";
        ExecStart = "/usr/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      };
      environment = {
        SSH_AUTH_SOCK="%t/ssh-agent.socket";
        DISPLAY=":0";
      };
      wantedBy = "default.target";
    };
  };
}
