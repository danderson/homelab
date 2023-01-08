{ config, pkgs, lib, ... }:
{
  options = {
  };

  config = lib.mkIf config.my.gui-programs {
    services = {
      swayidle.enable = true;
    };
    xdg.configFile."swaylock/config" = {
      text = ''
        show-keyboard-layout
        indicator-caps-lock
        color=000000
        ignore-empty-password
        show-failed-attempts
      '';
    };
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        fonts = {
          names = ["pango:DejaVu Sans Mono"];
          size = 11.0;
        };
        bars = [{
          mode = "dock";
          hiddenState = "hide";
          position = "top";
          workspaceButtons = true;
          workspaceNumbers = true;
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }];
        modes = {
          resize = {
            "j" = "resize shrink width 10 px or 10 ppt";
            "k" = "resize grow height 10 px or 10 ppt";
            "l" = "resize shrink height 10 px or 10 ppt";
            "semicolon" = "resize grow width 10 px or 10 ppt";
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Return" = ''mode "default"'';
            "Escape" = ''mode "default"'';
            "Mod4+r" = ''mode "default"'';
          };
        };
        output = {
          "${config.my.i3Monitors.mid}" = {
            res = "2560x1440";
            pos = "2560 383";
            # TODO: bg
          };
          "${config.my.i3Monitors.left}" = {
            res = "2560x1440";
            pos = "0 383";
          };
          "${config.my.i3Monitors.rightup}" = {
            res = "2560x1440";
            pos = "5120 0";
          };
          "${config.my.i3Monitors.rightdown}" = {
            res = "2560x1440";
            pos = "5120 1440";
          };
        };
        keybindings = let
          focusMonitor = which: if (which == "") then "nop" else "focus output ${which}";
          moveToMonitor = which: if (which == "") then "nop" else "move workspace to output ${which}";
        in {
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "Mod4+shift+y" = moveToMonitor config.my.i3Monitors.left;
          "Mod4+shift+u" = moveToMonitor config.my.i3Monitors.mid;
          "Mod4+shift+i" = moveToMonitor config.my.i3Monitors.rightdown;
          "Mod4+shift+o" = moveToMonitor config.my.i3Monitors.rightup;
          "Mod4+y" = focusMonitor config.my.i3Monitors.left;
          "Mod4+u" = focusMonitor config.my.i3Monitors.mid;
          "Mod4+i" = focusMonitor config.my.i3Monitors.rightdown;
          "Mod4+o" = focusMonitor config.my.i3Monitors.rightup;
          "Mod4+Shift+q" = "kill";
          "Mod4+d" = "exec ${pkgs.bemenu}/bin/bemenu-run";
          "Mod4+l" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
          "Mod4+n" = "exec ${pkgs.xdg-utils}/bin/xdg-open http://";
          "Mod4+Left" = "focus left";
          "Mod4+Down" = "focus down";
          "Mod4+Up" = "focus up";
          "Mod4+Right" = "focus right";
          "Mod4+Shift+Left" = "move left";
          "Mod4+Shift+Down" = "move down";
          "Mod4+Shift+Up" = "move up";
          "Mod4+Shift+Right" = "move right";
          "Mod4+h" = "split h";
          "Mod4+v" = "split v";
          "Mod4+f" = "fullscreen toggle";
          "Mod4+s" = "layout stacking";
          "Mod4+w" = "layout tabbed";
          "Mod4+e" = "layout toggle split";
          "Mod4+Shift+space" = "floating toggle";
          "Mod4+space" = "focus mode_toggle";
          "Mod4+a" = "focus parent";
          "Mod4+1" = "workspace number 1";
          "Mod4+2" = "workspace number 2";
          "Mod4+3" = "workspace number 3";
          "Mod4+4" = "workspace number 4";
          "Mod4+5" = "workspace number 5";
          "Mod4+6" = "workspace number 6";
          "Mod4+7" = "workspace number 7";
          "Mod4+8" = "workspace number 8";
          "Mod4+9" = "workspace number 9";
          "Mod4+0" = "workspace number 10";
          "Mod4+Shift+1" = "move container to workspace number 1";
          "Mod4+Shift+2" = "move container to workspace number 2";
          "Mod4+Shift+3" = "move container to workspace number 3";
          "Mod4+Shift+4" = "move container to workspace number 4";
          "Mod4+Shift+5" = "move container to workspace number 5";
          "Mod4+Shift+6" = "move container to workspace number 6";
          "Mod4+Shift+7" = "move container to workspace number 7";
          "Mod4+Shift+8" = "move container to workspace number 8";
          "Mod4+Shift+9" = "move container to workspace number 9";
          "Mod4+Shift+0" = "move container to workspace number 10";
          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+r" = "restart";
          "Mod4+Shift+e" = "exec ${pkgs.sway}/bin/swaynag -t warning -m 'Really exit?' -B 'Yes' '${pkgs.sway}/bin/swaymsg exit'";
          "Mod4+r" = ''mode "resize"'';
          "Mod4+p" = "exec /home/dave/bin/layout _interactive";
        };
        startup = [
          { command = "swayidle -w timeout 1800 'swaylock' lock 'swaylock'"; }
        ];
      };
    };
  };
}
