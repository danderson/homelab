{ config, pkgs, lib, ... }: let
  i3StartupCmds = cmds: map (c: {command = c; notification = false; }) cmds;
  swayStartupCmds = cmds: map (c: {command = c;}) cmds;

  universalScript = i3Cmd: swayCmd: pkgs.writeScript "script" ''
    #!/usr/bin/env sh
    if [ "''${XDG_SESSION_DESKTOP:-}" = "sway" ]; then
      exec ${swayCmd} $@
    else
      exec ${i3Cmd} $@
    fi
  '';
  universalNag = universalScript "${pkgs.i3}/bin/i3-nagbar" "${pkgs.sway}/bin/swaynag";
  universalMsg = universalScript "${pkgs.i3}/bin/i3-msg" "${pkgs.sway}/bin/swaymsg";

  # Bits of config shared by i3 and sway
  wmConfig = {
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
    window.commands = let
      floatingRoles = [
        "About"
        "Organizer"
        "Preferences"
        "bubble"
        "dialog"
        "menu"
        "page-info"
        "pop-up"
        "task_dialog"
        "toolbox"
        "webconsole"
      ]; in map (r: { criteria.window_role = r; command = "floating enable"; }) floatingRoles;
  };

  # Shared keybindings between i3 and sway
  keybindings = {
    "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
    "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
    "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
    "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    "XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.acpilight}/bin/xbacklight -perceived -inc 5";
    "XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.acpilight}/bin/xbacklight -perceived -dec 5";
    "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
    "Mod4+Shift+q" = "kill";
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
    "Mod4+shift+e" = "exec ${universalNag} -t warning -m 'Really exit?' -B 'Yes' '${universalMsg} exit'";
    "Mod4+Shift+space" = "floating toggle";
    "Mod4+space" = "focus mode_toggle";
    "Mod4+d" = "exec ${pkgs.bemenu}/bin/bemenu-run";
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
    "Mod4+r" = ''mode "resize"'';
    "Mod4+p" = "exec ${pkgs.my.layout}/bin/layout --interactive";
  };

  barConfig = x11: [{
    mode = "dock";
    hiddenState = "hide";
    position = "top";
    workspaceButtons = true;
    workspaceNumbers = true;
    statusCommand = "${pkgs.i3status}/bin/i3status";
    trayOutput = if x11 then "primary" else null;
  }];

  format = pkgs.formats.json {};
  layoutCfg = format.generate "layout.json" config.my.layout;
  swayLayout = pkgs.runCommandLocal "sway-layout" {} ''${pkgs.my.layout}/bin/layout --config ${layoutCfg} --gen-sway >$out'';
  i3Layout = pkgs.runCommandLocal "i3-layout" {} ''${pkgs.my.layout}/bin/layout --config ${layoutCfg} --gen-i3 >$out'';

in lib.mkIf config.my.desktop {
  xsession.windowManager.i3 = {
    enable = true;
    config = wmConfig // {
      bars = barConfig true;
      keybindings = keybindings;

      startup = i3StartupCmds ([
        "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${pkgs.i3lock}/bin/i3lock -e -f --nofork --color=000000"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
      ] ++ config.my.wmCommands);
    };
    extraConfig = ''
      include ${i3Layout}
    '';
  };

  wayland.windowManager.sway = {
    enable = true;
    config = wmConfig // {
      bars = barConfig false;
      keybindings = keybindings;
      startup = swayStartupCmds config.my.wmCommands;
    };
    extraConfig = ''
      include ${swayLayout}
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
      "tztime paris" = {
        position = 3;
        settings = {
          format = "%H:%M Paris";
          timezone = "Europe/Paris";
        };
      };
      "tztime toronto" = {
        position = 4;
        settings = {
          format = "%H:%M Toronto";
          timezone = "America/Toronto";
        };
      };
      "tztime victoria" = {
        position = 5;
        settings = {
          format = "%H:%M:%S";
          timezone = "America/Vancouver";
        };
      };
      "time" = {
        position = 6;
        settings = {
          format = "%Y-%m-%d";
        };
      };
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.systemd}/bin/loginctl lock-session"; }
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock"; }
    ];
    timeouts = [
      { timeout = 1800; command = "${pkgs.systemd}/bin/loginctl lock-session"; }
    ];
  };

  xdg.configFile."layout/config".source = layoutCfg;

  xdg.configFile."swaylock/config" = {
    text = ''
      show-keyboard-layout
      indicator-caps-lock
      color=111111
      ignore-empty-password
      show-failed-attempts
      daemonize
      indicator-idle-visible
    '';
  };
}
