{
  users.users.jjy = {
    home = "/Users/jjy";
  };

  system = {
    primaryUser = "jjy";
    defaults = {
      trackpad = {
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  time.timeZone = "Asia/Shanghai";

  homebrew = {
    enable = true;

    brews = [
      "docker"
    ];
    casks = [
      "kitty"
      "tailscale"
      "orbstack"
      "localsend"
      "obsidian"
    ];
  };

  system.stateVersion = 6;
}
