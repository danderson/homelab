{ lib, ... }: {
  system.activationScripts.keys = lib.stringAfter [ "users" "groups" ]
    ''
      # Set permissions for keys
      (
        if [[ -f /etc/keys/files ]]; then
          cat /etc/keys/files | while read name owner group mode; do
            touch -a "/etc/keys/''${name}"
            chown "''${owner}:''${group}" "/etc/keys/''${name}"
            chmod ''${mode} /etc/keys/''${name}
          done
        fi
      )
    '';
}
