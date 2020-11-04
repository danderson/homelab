{ config, pkgs, ... }:
let
  console-programs = with pkgs; [
    file
    fping
    git-crypt
    go
    ipcalc
    lftp
    mosh
    nmap
    pwgen
  ];
  gui-programs = with pkgs; [
    gnome3.dconf-editor
    gimp
    google-chrome
    graphviz
    pavucontrol
    pdftk
    steam
  ];
  has-gui = config.services.xserver.enable;
in
{
  environment.pathsToLink = [ "/share/zsh" ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.dave = {
      home = {
        packages = console-programs ++ (if has-gui then gui-programs else []);
        stateVersion = "20.09";
      };
      programs = {
        direnv = {
          enable = true;
          enableNixDirenvIntegration = true;
        };
        dircolors.enable = true;
        feh.enable = has-gui;
        git = {
          enable = true;
          aliases = {
            st = "status";
            br = "branch";
            ci = "commit";
            di = "diff";
            co = "checkout";
            lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
            lg2 = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
          };
          # TODO: delta?
          extraConfig = {
            core.editor = "nano";
            color.ui = "auto";
            push.default = "current";
          };
          userName = "David Anderson";
          userEmail = "dave@natulte.net";
          ignores = [ "*.o" "*.pyc" "*.pyo" "*.elc" "*~" ];
        };
        go = {
          enable = true;
          goBin = ".local/go.bin";
          goPath = ".local/go.path";
        };
        lesspipe.enable = true;
        # Shell prompt: powerline? starship?
        # zathura?
        ssh = {
          enable = false;
          # TODO: moar
          controlMaster = "auto";
          controlPersist = "10m";
        };
        zsh = {
          enable = true;
          enableAutosuggestions = true;
          enableCompletion = true;
          enableVteIntegration = true;
          history = {
            extended = true;
            ignoreDups = true;
            ignoreSpace = true;
            save = 100000;
            size = 100000;
          };
          oh-my-zsh = { # prezto?...
            enable = true;
            theme = "robbyrussell";
            plugins = [ "colored-man-pages" "docker" "git" "golang" "mosh" ];
          };
          shellAliases = {
            e = "emacsclient -n";
          };
          sessionVariables = {
            EDITOR = "emacsclient";
            PAGER = "less -X";
            LESS = "-R";
          };
          initExtra = ''
            function make_prompt() {
              local host_color
              if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
                host_color='%F{yellow}'
              else
                host_color='%F{green}'
              fi

              local time="%F{cyan}%*%f" # 24-hour, second resolution
              local user='%(!.%F{red}.%F{green})%n%f' # red if root, else green
              local at='%F{cyan}@%f'
              local host="$host_color%m%f"
              local dir='%B%F{blue}%3~%f%b'

              echo "''${time} ''${user}''${at}''${host} ''${dir} » "
            }
            PROMPT="$(make_prompt)"
          '';
        };
      };
    };
  };
}
