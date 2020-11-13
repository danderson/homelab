{
  programs.git = {
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
    ignores = [ "*.o" "*.pyc" "*.pyo" "*.elc" "*~" ".direnv/*" ];
  };
}
