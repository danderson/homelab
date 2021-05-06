{ config, pkgs, lib, ... }:
lib.mkIf config.my.gui-programs {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      bars = [{
        statusCommand = "${pkgs.i3status}/bin/i3status";
        position = "top";
      }];
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      fonts = ["pango:DejaVu Sans Mono 10"];
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
      startup = [
        {
          command = "xss-lock --transfer-sleep-lock -- ${pkgs.i3lock}/bin/i3lock --nofork --color=000000";
          notification = false;
        }
        {
          command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
          notification = false;
        }
      ];
      keybindings = {
        "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "Mod4+m" = "move workspace to output primary";
        "Mod4+Shift+q" = "kill";
        "Mod4+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "Mod4+l" = "exec ${pkgs.i3lock}/bin/i3lock --color=000000";
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
        "Mod4+1" = "workspace number $ws1";
        "Mod4+2" = "workspace number $ws2";
        "Mod4+3" = "workspace number $ws3";
        "Mod4+4" = "workspace number $ws4";
        "Mod4+5" = "workspace number $ws5";
        "Mod4+6" = "workspace number $ws6";
        "Mod4+7" = "workspace number $ws7";
        "Mod4+8" = "workspace number $ws8";
        "Mod4+9" = "workspace number $ws9";
        "Mod4+0" = "workspace number $ws10";
        "Mod4+Shift+1" = "move container to workspace number $ws1";
        "Mod4+Shift+2" = "move container to workspace number $ws2";
        "Mod4+Shift+3" = "move container to workspace number $ws3";
        "Mod4+Shift+4" = "move container to workspace number $ws4";
        "Mod4+Shift+5" = "move container to workspace number $ws5";
        "Mod4+Shift+6" = "move container to workspace number $ws6";
        "Mod4+Shift+7" = "move container to workspace number $ws7";
        "Mod4+Shift+8" = "move container to workspace number $ws8";
        "Mod4+Shift+9" = "move container to workspace number $ws9";
        "Mod4+Shift+0" = "move container to workspace number $ws10";
        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+r" = "restart";
        "Mod4+Shift+e" = ''exec "${pkgs.i3}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' '${pkgs.i3}/bin/i3-msg exit'"'';
        "Mod4+r" = ''mode "resize"'';
      };
    };
  };
  programs.i3status = {
    enable = true;
    general = {
      output_format = "i3bar";
      interval = 5;
    };
    modules = {
      "wireless wlan0" = {
        position = 1;
        settings = {
          format_up = "W: %ip (%quality)";
          format_down = "!W";
          format_quality = "%2d%s";
        };
      };
      "ethernet enp3s0f0" = {
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
}
