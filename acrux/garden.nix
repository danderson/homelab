{ config, pkgs, flakes, ... }:
{
  systemd.services.garden = {
    description = "Garden management app";
    path = [pkgs.sqlite-interactive];
    unitConfig = {
      ConditionPathExists = "/fast/garden/garden.bin";
    };
    serviceConfig = {
      ExecStart = "/fast/garden/garden.bin --state-dir=/fast/garden/state --hostname=garden";
      WorkingDirectory = "/fast/garden";
      User = "dave";
      Group = "nogroup";
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateIPC = true;
      PrivateUsers = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      #SystemCallFilter = "@system-service";
      SystemCallArchitectures = "native";
      Restart = "always";
    };
  };
}
