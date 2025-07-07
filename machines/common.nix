{pkgs, ...}: {
  time.timeZone = "Asia/Shanghai";


# Enable CUPS to print documents.
  services.printing.enable = true;

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
         bluetooth.autoswitch-to-headset-profile = false
         '')
      ];
    };
  };


services.xserver.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
services.libinput.enable = true;

environment.variables = {
  XDG_RUNTIME_DIR = "/run/user/$UID";
};

environment.sessionVariables = {
# These are the defaults, and xdg.enable does set them, but due to load
# order, they're not set before environment.variables are set, which could
# cause race conditions.
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_BIN_HOME = "$HOME/.local/bin";
  MOA_ENABLE_WAYLAND = 1;
  XDG_CURRENT_DESKTOP = "Hyprland";
  XDG_SESSION_DESKTOP = "Hyprland";
  XDG_SESSION_TYPE = "wayland";
  GDK_BACKEND = "wayland,x11";
  QT_QPA_PLATFORM = "wayland,xcb";

  # templates = "${self}/dev-shells";
};

environment.systemPackages = with pkgs; [
  killall
  wofi
];
}
