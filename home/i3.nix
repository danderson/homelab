{ config, pkgs, lib, ... }:
{
  options = {
    my.home-desk = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.my.gui-programs {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        bars = [{
          statusCommand = "${pkgs.i3status}/bin/i3status";
          position = "top";
        }];
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        fonts = {
          names = ["pango:DejaVu Sans Mono"];
          size = 11.0;
        };
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
        startup = let
          cmds = [
            "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${pkgs.i3lock}/bin/i3lock -e -f --nofork --color=000000"
            "${pkgs.networkmanagerapplet}/bin/nm-applet"
          ];
          home-desk-cmds = if config.my.home-desk then [
            "${pkgs.xorg.xrandr}/bin/xrandr --output DisplayPort-0 --primary --mode 2560x1440 --rate 75 --pos 2560x383 --rotate normal --output DisplayPort-1 --mode 2560x1440 --rate 75 --pos 0x383 --rotate normal --output DisplayPort-2 --mode 2560x1440 --rate 75 --pos 5120x1440 --rotate normal --output HDMI-A-0 --mode 2560x1440 --rate 75 --pos 5120x0 --rotate normal"
            "${pkgs.openrgb}/bin/openrgb -p magenta.orp"
            "${pkgs.openrgb}/bin/openrgb --gui --startminimized"
            "${pkgs.picom}/bin/picom -CGb"
            "${pkgs.nitrogen}/bin/nitrogen --restore"
          ] else [];
        in map (c: { command = c; notification = false; }) (cmds ++ home-desk-cmds);
        keybindings = {
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "Mod4+shift+y" = "move workspace to output DisplayPort-1";
          "Mod4+shift+u" = "move workspace to output DisplayPort-0";
          "Mod4+shift+i" = "move workspace to output DisplayPort-2";
          "Mod4+shift+o" = "move workspace to output HDMI-A-0";
          "Mod4+y" = "focus output DisplayPort-1";
          "Mod4+u" = "focus output DisplayPort-0";
          "Mod4+i" = "focus output DisplayPort-2";
          "Mod4+o" = "focus output HDMI-A-0";
          "Mod4+Shift+q" = "kill";
          "Mod4+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
          "Mod4+l" = "exec ${pkgs.systemd}/bin/loginctl lock-session";
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
          "Mod4+1" = "workspace 1: emacs";
          "Mod4+2" = "workspace 2: browsing";
          "Mod4+3" = "workspace 3: comms";
          "Mod4+4" = "workspace number 4";
          "Mod4+5" = "workspace number 5";
          "Mod4+6" = "workspace number 6";
          "Mod4+7" = "workspace number 7";
          "Mod4+8" = "workspace number 8";
          "Mod4+9" = "workspace number 9";
          "Mod4+0" = "workspace 10: video";
          "Mod4+Shift+1" = "move container to workspace 1: emacs";
          "Mod4+Shift+2" = "move container to workspace 2: browsing";
          "Mod4+Shift+3" = "move container to workspace 3: comms";
          "Mod4+Shift+4" = "move container to workspace number 4";
          "Mod4+Shift+5" = "move container to workspace number 5";
          "Mod4+Shift+6" = "move container to workspace number 6";
          "Mod4+Shift+7" = "move container to workspace number 7";
          "Mod4+Shift+8" = "move container to workspace number 8";
          "Mod4+Shift+9" = "move container to workspace number 9";
          "Mod4+Shift+0" = "move container to workspace 10: video";
          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+r" = "restart";
          "Mod4+Shift+e" = ''exec "${pkgs.i3}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' '${pkgs.i3}/bin/i3-msg exit'"'';
          "Mod4+r" = ''mode "resize"'';
          "Mod4+p" = "exec /home/dave/bin/layout _interactive";
        };
        window.commands = [
          {
            criteria = { window_role = "pop-up"; };
            command = "floating enable";
          }
        ];
      };
      extraConfig = ''
        title_align center
        assign [class="emacs"] "1: emacs"
        assign [class="Firefox" window_type="normal"] "2: browsing"
        assign [class="Alactritty" title="^\[mosh\] "] "3: comms"
        assign [class=".obs-wrapped"] "8: obs"
        assign [class="Steam"] "9: game"
        workspace "1: emacs" output DisplayPort-0
        workspace "2: browsing" output DisplayPort-1
        workspace "3: comms" output DisplayPort-2
        workspace "10: video" output HDMI-A-0
      '';
    };
    programs.i3status = {
      enable = true;
      enableDefault = false;
      general = {
        output_format = "i3bar";
        interval = 5;
      };
      modules = {
        "ipv6" = {
          position = 1;
        };
        "wireless wlan0" = {
          position = 1;
          settings = {
            format_up = "W: %ip (%quality)";
            format_down = "!W";
            format_quality = "%2d%s";
          };
        };
        "ethernet enp5s0" = {
          position = 2;
          settings = {
            format_up = "E: %ip";
            format_down = "!E";
          };
        };
        "ethernet enp4s0" = {
          position = 2;
          settings = {
            format_up = "E: %ip";
            format_down = "!E";
          };
        };
        "tztime victoria" = {
          position = 3;
          settings = {
            format = "%time";
            format_time = "%H:%M %Z";
            timezone = "America/Vancouver";
            hide_if_equals_localtime = true;
          };
        };
        "tztime toronto" = {
          position = 4;
          settings = {
            format = "%time";
            format_time = "%H:%M %Z";
            timezone = "America/Toronto";
            hide_if_equals_localtime = true;
          };
        };
        "tztime paris" = {
          position = 5;
          settings = {
            format = "%time";
            format_time = "%H:%M %Z";
            timezone = "Europe/Paris";
            hide_if_equals_localtime = true;
          };
        };
        "time" = {
          position = 6;
        };
      };
    };
  };
}
