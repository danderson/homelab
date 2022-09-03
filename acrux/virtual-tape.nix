{ flakes, ... }:
{
  containers.vtl = {
    autoStart = true;
    ephemeral = true;
    bindMounts = {
      "/data/vtl" = {
        hostPath = "/data/vtl";
        isReadOnly = false;
      };
    };
    config = {
      # Inject the flakes parameter into the container's evaluation
      # environment. Because of the way declarative containers work,
      # they don't get evaluated with the full module context of their
      # parent, and don't provide a handy place to inject
      # this. Fortunately, doing the obvious thing of "smash the value
      # into the module by hand" seems to work correctly, muahahah.
      _module.args.flakes = flakes;
      system.stateVersion = "22.05";

      imports = [
        ../lib
      ];

      # TODO: build a VTL derivation and run it.
    };
  };
}
