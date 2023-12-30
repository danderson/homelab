{ pkgs, lib, flakes, ...}: let
  bsvPkg = (pkgs.emacsPackagesFor pkgs.emacs29).trivialBuild {
    pname = "bsv-mode";
    version = "0.0";
    src = pkgs.fetchFromGitHub {
      owner = "danderson";
      repo = "bsv-mode";
      rev = "dd526198472c977a2350aefb0594da322b14e5f9";
      sha256 = "sha256-QcgDivhRKaiWNvSIH/0rKQvxprEN6N+bAxyp9iCcmiM=";
    };
  };

  gasPkg = (pkgs.emacsPackagesFor pkgs.emacs29).trivialBuild {
    pname = "gas-mode";
    version = "0.0";
    src = ./emacs/gas-mode.el;
  };

  externalGrammars = [
    # Until https://github.com/NixOS/nixpkgs/pull/277771 is merged
    flakes.nixos-dave.legacyPackages.x86_64-linux.tree-sitter-grammars.tree-sitter-templ
  ];

  addExternalGrammars = grammars: (builtins.attrValues grammars) ++ externalGrammars;

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs29;
    config = ./emacs/init.el;
    extraEmacsPackages = epkgs: with epkgs; [
      use-package
      diminish
      (treesit-grammars.with-grammars addExternalGrammars)
      bsvPkg
      gasPkg
    ];
    alwaysEnsure = true;
  };
  fastSwank = pkgs.runCommandWith {name = "sbcl.core-with-swank";} ''
    export HOME=`pwd`
    loader=$(echo ${pkgs.emacsPackages.slime}/share/emacs/site-lisp/elpa/slime-*/swank-loader.lisp)
    ${pkgs.sbcl}/bin/sbcl --eval "(load \"$loader\")" --eval "(swank-loader:dump-image \"$out\")"
  '';
in {
  home.packages = [ emacs ];
  home.file.".emacs.d/init.el".text = builtins.readFile ./emacs/init.el;
  home.file.".emacs.d/early-init.el".text = builtins.readFile ./emacs/early-init.el;
  home.file.".emacs.d/slime-loader.el".text = ''
    (setq my/slime-precompiled "${fastSwank}")
  '';
}
