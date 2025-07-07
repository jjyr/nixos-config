{
# Enable sddm login manager
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      settings.Theme.CursorTheme = "Bibata-Modern-Classic";
      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
          kdePackages.qtsvg
          kdePackages.qtvirtualkeyboard
      ];
    };
  };

# Setup keyring
  services.gnome.gnome-keyring.enable = true;

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
}

services.xserver.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
services.libinput.enable = true;

environment.sessionVariables = {
# These are the defaults, and xdg.enable does set them, but due to load
# order, they're not set before environment.variables are set, which could
# cause race conditions.
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_BIN_HOME = "$HOME/.local/bin";

  templates = "${self}/dev-shells";
};

environment.systemPackages = with pkgs; [
  killall
  lm_sensors
  jq
  bibata-cursors
  sddm-astronaut # Overlayed
  pkgs.kdePackages.qtsvg
  pkgs.kdePackages.qtmultimedia
  pkgs.kdePackages.qtvirtualkeyboard

# devenv
# devbox
# shellify
];
