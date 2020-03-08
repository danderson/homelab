{
  systemd.services.natprobe = {
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "/natprobe";
      Restart = "always";
      RestartSec = 5;
      RootDirectory = "/root/natprobe";
      MountAPIVFS = false;
      DynamicUser = true;
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      NoNewPrivileges = true;
      SecureBits = "no-setuid-fixup-locked noroot-locked keep-caps";
      KeyringMode = "private";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHostname = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = "AF_UNIX AF_NETLINK AF_INET AF_INET6";
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;
      SystemCallFilter = "@system-service @network-io";
      SystemCallArchitectures = "native";
    };
  };
}
