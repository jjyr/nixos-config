{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    waybar
  ];

  programs.waybar = {
    enable = true;

    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "power-profiles-daemon"
          "battery"
        ];
        "hyprland/workspaces" = {
          "on-click" = "activate";
          "format" = "{icon}";
          "format-icons" = {
            "default" = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "active" = "󱓻";
          };
          "persistent-workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        "cpu" = {
          "interval" = 5;
          "format" = "󰍛";
          "on-click" = "alacritty -e btop";
        };
        "clock" = {
          "timezone" = "Asia/Shanghai";
          "format" = "{:%y-%m-%d %H:%M %a}";
          "tooltip" = false;
        };
        "network" = {
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          "format" = "{icon}";
          "format-wifi" = "{icon}";
          "format-ethernet" = "󰀂";
          "format-disconnected" = "󰖪";
          "tooltip-format-wifi" = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-ethernet" = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-disconnected" = "Disconnected";
          "interval" = 3;
          "nospacing" = 1;
          "on-click" = "alacritty -e iwctl";
        };
        "battery" = {
          "format" = "{capacity}% {icon}";
          "format-discharging" = "{icon}";
          "format-charging" = "{icon}";
          "format-plugged" = "";
          "format-icons" = {
            "charging" = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            "default" = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
          "format-full" = "Charged ";
          "tooltip-format-discharging" = "{power:>1.0f}W↓ {capacity}%";
          "tooltip-format-charging" = "{power:>1.0f}W↑ {capacity}%";
          "interval" = 5;
          "states" = {
            "warning" = 20;
            "critical" = 10;
          };
        };
        "bluetooth" = {
          "format" = "";
          "format-disabled" = "󰂲";
          "format-connected" = "";
          "tooltip-format" = "Devices connected: {num_connections}";
          "on-click" = "GTK_THEME=Adwaita-dark blueberry";
        };
        "pulseaudio" = {
          "format" = "";
          "format-muted" = "󰝟";
          "scroll-step" = 5;
          "on-click" = "GTK_THEME=Adwaita-dark pavucontrol";
          "tooltip-format" = "Playing at {volume}%";
          "on-click-right" = "pamixer -t";
          "ignored-sinks" = [ "Easy Effects Sink" ];
        };
        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = "Power profile: {profile}";
          "tooltip" = true;
          "format-icons" = {
            "power-saver" = "󰡳";
            "balanced" = "󰊚";
            "performance" = "󰡴";
          };
        };
      }
    ];
    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: CaskaydiaMono Nerd Font;
        font-size: 13px;
      }

      #waybar {
        background: transparent;
        color: #c6d0f5;
        margin: 0px;
        font-weight: 500;
      }

      #workspaces,
      #cpu {
        background-color: #1a1b26;
        padding: 0.3rem 0.7rem;
        margin: 5px 0px; /* 5px top/bottom margin, 0px left/right (base for individual control) */
        border-radius: 6px; /* These modules are always rounded */
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        min-width: 0;
        border: none;
        /* Transition for background-color and color only */
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
      }

      #workspaces {
        padding: 2px;
        margin-left: 7px; /* Margin from the far left edge */
        margin-right: 5px; /* Spacing after the workspaces module */
      }

      #cpu:hover {
        background-color: rgb(41, 42, 53); /* Brighter highlight */
      }

      #workspaces button {
        color: #babbf1;
        border-radius: 5px; /* Workspaces buttons are always rounded */
        padding: 0.3rem 0.6rem;
        background: transparent;
        transition: all 0.2s ease-in-out;
        border: none;
        outline: none;
      }

      #workspaces button.active {
        color: #99d1db;
        background-color: rgba(153, 209, 219, 0.1);
        box-shadow: inset 0 0 0 1px rgba(153, 209, 219, 0.2);
      }

      #workspaces button:hover {
        background: rgb(41, 42, 53); /* Reference bright hover color */
        color: #c6d0f5;
      }

      /* --- Center Module (Individual, Fully Rounded Block - With Simple Hover) --- */
      #clock {
        background-color: #1a1b26;
        padding: 0.3rem 0.7rem;
        margin: 5px 0px;
        border-radius: 6px; /* This module is always rounded */
        box-shadow: 0 1px 3px rgba(153, 209, 219, 0.2);
        min-width: 0;
        border: none;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
      }

      /* Simple Hover effect for clock module - BRIGHTER COLOR */
      #clock:hover {
        background-color: rgba(153, 209, 219, 0.1); /* Brighter highlight */
      }


      #power-profiles-daemon,
      #battery,
      #network,
      #bluetooth,
      #pulseaudio {
        background-color: #1a1b26;
        padding: 0.3rem 0.7rem;
        margin: 5px 0px; 
        border-radius: 0;
        box-shadow: none;
        min-width: 0;
        border: none;
        transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
      }

      #bluetooth:hover,
      #pulseaudio:hover,
      #backlight:hover,
      #network:hover,
      #custom-lock:hover,
      #battery:hover {
        background-color: rgb(41, 42, 53);
      }

      #bluetooth {
        margin-left: 0px; 
        border-top-left-radius: 6px;
        border-bottom-left-radius: 6px;
      }

      #battery {
        border-top-right-radius: 6px;
        border-bottom-right-radius: 6px;
        margin-right: 7px;
      }

      #custom-uptime {
        color: #babbf1;
      }
      #cpu {
        color: #c6d0f5;
      }

      #clock {
        color: #99d1db;
        font-weight: 500;
      }

      #pulseaudio {
        color: #c6d0f5;
      }
      #backlight {
        color: #c6d0f5;
      }

      #network {
        color: #c6d0f5;
      }

      #network.disconnected {
        color: #e78284;
      }

      #custom-lock {
        color: #babbf1;
      }
      #bluetooth {
        color: #888888;
        font-size: 16px;
      }
      #bluetooth.on {
        color: #2196f3;
      }
      #bluetooth.connected {
        color: #99d1db;
      }
      #battery {
        color: #99d1db;;
      }
      #battery.charging {
        color: #a6d189;
      }
      #battery.warning:not(.charging) {
        color: #e78284;
      }

      /* --- Tooltip Styles --- */
      tooltip {
        background-color: #1a1b26;
        color: #dddddd;
        padding: 5px 12px;
        margin: 5px 0px;
        border-radius: 6px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        font-size: 12px;
      }
    '';
  };
}
