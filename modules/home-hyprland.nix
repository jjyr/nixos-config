Z
  pkgs,
  inputs,
  nvidia,
  preventlock,
  ...
}:
{
  environment.systemPackages = [pkgs.kitty];

  programs.hyprland.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    systemd.variables = ["--all"];

    settings = {
      monitor = ",preferred,auto,auto";

      xwayland = {
        force_zero_scaling = true;
      };
      ecosystem = {
        no_update_news = true;
      };
      bind =
        let
          terminal = "alacritty";
          fileManager = "nautilus --new-window";
          browser = "chromium --new-window --ozone-platform=wayland";
          lockScreenBind = if preventlock then [] else [

            # end sessions
            "SUPER, ESCAPE, exec, hyprlock"
            "SUPER SHIFT, ESCAPE, exec, systemctl suspend"

          ];
        in
        lockScreenBind ++
        [
          "SUPER ALT, ESCAPE, exit"
          "SUPER, return, exec, ${terminal}"
          "SUPER, F, exec, ${fileManager}"
          "SUPER, B, exec, ${browser}"
          "SUPER, T, exec, ${terminal} -e btop"
          "SUPER, space, exec, flock --nonblock /tmp/.wofi.lock -c \"wofi -- show drun --sort-order=alphabetical\""
          "SUPER_CTRL, space, execr, fcitx5-remote -t"
          "SUPER, O, exec, obsidian --no-sandbox %U --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime"
          "SUPER, W, killactive"

          # tiling
          "SUPER, J, togglesplit, # dwindle"
          "SUPER, P, pseudo, # dwindle"
          "SUPER, V, togglefloating,"

          # move focus
          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          # switch workspaces
          "SUPER, 1, workspace, 1"
          "SUPER, 2, workspace, 2"
          "SUPER, 3, workspace, 3"
          "SUPER, 4, workspace, 4"
          "SUPER, 5, workspace, 5"
          "SUPER, 6, workspace, 6"
          "SUPER, 7, workspace, 7"
          "SUPER, 8, workspace, 8"
          "SUPER, 9, workspace, 9"
          "SUPER, 0, workspace, 10"
          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "SUPER SHIFT, 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, movetoworkspace, 9"
          "SUPER SHIFT, 0, movetoworkspace, 10"

          # Swap active window with the one next to it with mainMod + SHIFT + arrow keys
          "SUPER SHIFT, left, swapwindow, l"
          "SUPER SHIFT, right, swapwindow, r"
          "SUPER SHIFT, up, swapwindow, u"
          "SUPER SHIFT, down, swapwindow, d"

          # Resize active window
          "SUPER, minus, resizeactive, -100 0"
          "SUPER, equal, resizeactive, 100 0"
          "SUPER SHIFT, minus, resizeactive, 0 -100"
          "SUPER SHIFT, equal, resizeactive, 0 100"

          # Scroll through existing workspaces with mainMod + scroll
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"

          # screenshot
          ", PRINT, exec, hyprshot -m region"
          "SHIFT, PRINT, exec, hyprshot -m window"
          "CTRL, PRINT, exec, hyprshot -m output"
        ];

      # Enable ime
      exec-once = [
        "fcitx5-remote -r"
        "fcitx5-remote -d --replace &"
        "fcitx5-remote -r"
      ];

      # input
      input = {
        kb_layout = "us";
        kb_options = "compose:caps";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = true;
      };
      gestures = {
        workspace_swipe = false;
      };

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = "yes, please :)";

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
        force_split = 2; # Always split on the right
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      env =
        let
          ENV = [
            # cursor
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            # force wayland
            "GDK_BACKEND,wayland"
            "QT_QPA_PLATFORM,wayland"
            "QT_STYLE_OVERRIDE,kvantum"
            "SDL_VIDEODRIVER,wayland"
            "MOZ_ENABLE_WAYLAND,1"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
            "OZONE_PLATFORM,wayland"
            # chrome
            "CHROMIUM_FLAGS,\"--enable-features=UseOzonePlatform --ozone-platform=wayland --gtk-version=4\""
            "XDG_DATA_DIRS,/usr/share:/usr/local/share:~/.local/share"
            "XCOMPOSEFILE,~/.XCompose"
            "GDK_SCALE,2"
            "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/ssh-agent.socket"
          ];
        in
        if nvidia then
          [
            "NVD_BACKEND,direct"
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ]
          ++ ENV
        else
          ENV;

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrule = [
        "suppressevent maximize, class:.*"
        # Force chromium into a tile to deal with --app bug
        "tile, class:^(Chromium)$"
        # Float sound and bluetooth settings
        "float, class:^(org.pulseaudio.pavucontrol|blueberry.py)$"
        # Float Steam, fullscreen RetroArch
        "float, class:^(steam)$"
        "fullscreen, class:^(com.libretro.RetroArch)$"

        # Just dash of opacity
        "opacity 0.97 0.9, class:.*"
        "opacity 1 0.97, class:^(Chromium|chromium|google-chrome|google-chrome-unstable)$"
        "opacity 1 1, initialTitle:^(youtube.com_/)$ # Youtube"
        "opacity 1 1, class:^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta)$"
        "opacity 1 1, class:^(com.libretro.RetroArch|steam)$"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        # Float in the middle for clipse clipboard manager
        "float, class:(clipse)"
        "size 622 652, class:(clipse)"
        "stayfocused, class:(clipse)"
      ];

      # Proper background blur for wofi
      layerrule = [ "blur,wofi" ];

    };
  };

}

