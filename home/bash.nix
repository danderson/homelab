{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    sessionVariables = {
      EDITOR = "emacsclient";
      PAGER = "less -X";
      LESS = "-R";
    };
    shellAliases = {
      e = "emacsclient -n";
    };
    shellOptions = [ "histappend" ];
    initExtra = ''
      # Nice and simple, no frills. It's only bash, after all.
      if [[ `whoami` == "root" ]]; then
          PS1='\e[31m\u\e[0m@\h#'
      else
          PS1='\u@\h$'
      fi
    '';
  };
}
