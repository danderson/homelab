{
  programs.ssh = {
    enable = true;
    matchBlocks."*".proxyCommand = "$HOME/bin/ts-ssh-proxy -bastion-user=danderson %r %h %p";
  };
}
