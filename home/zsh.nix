{ lib, ... }: {
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
      theme = "simple";
      plugins = [ "colored-man-pages" "docker" "git" "golang" "mosh" ];
    };
    shellAliases = {
      e = "emacsclient -n";
    };
    sessionVariables = {
      EDITOR = "emacsclient";
      PAGER = "less -X";
      LESS = "-R";
      #DIRENV_LOG_FORMAT = "";
    };
    initExtra = lib.strings.concatMapStringsSep "\n" builtins.readFile [
      ./zsh-prompt.sh
      ./zsh-funcs.sh
    ];
  };
}
