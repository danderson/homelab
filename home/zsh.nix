{
  # Adds autocompletes from installed packages to zsh universe.
  programs.zsh = {
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
    # My prompt
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
      RPROMPT=""

      function nixos-diff() {
        old=$1
        new=$2
        nix-diff --color=always $(nix-store -qd $old $new)
      }
    '';
  };
}
