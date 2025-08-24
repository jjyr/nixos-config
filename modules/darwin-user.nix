{
  users.users.jjy = {
    home = "/Users/jjy";
  };

  system = {
    primaryUser = "jjy";
    defaults = {
      trackpad.TrackpadThreeFingerDrag = true;
    };
  };

  time.timeZone = "Asia/Shanghai";

  homebrew = {
    enable = true;
    casks = [
      "tailscale"
    ];
  };

  system.stateVersion = 6;
}
