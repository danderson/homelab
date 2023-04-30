{ pkgs, lib, ...}: let
  em = pkgs.emacsPackagesFor pkgs.emacs;
  bsvPkg = emPkgs: emPkgs.trivialBuild {
    pname = "bsv-mode";
    version = "0.0";
    src = pkgs.fetchFromGitHub {
      owner = "danderson";
      repo = "bsv-mode";
      rev = "dd526198472c977a2350aefb0594da322b14e5f9";
      sha256 = "sha256-QcgDivhRKaiWNvSIH/0rKQvxprEN6N+bAxyp9iCcmiM=";
    };
  };
  fastSwank = pkgs.runCommandWith {name = "sbcl.core-with-swank";} ''
    export HOME=`pwd`
    loader=$(echo ${pkgs.emacsPackages.slime}/share/emacs/site-lisp/elpa/slime-*/swank-loader.lisp)
    ${pkgs.sbcl}/bin/sbcl --eval "(load \"$loader\")" --eval "(swank-loader:dump-image \"$out\")"
  '';
  pkg = opts: { enable = lib.mkDefault true; } // opts;
  ext = str: ''"${builtins.replaceStrings ["." "'"] [''\\.'' ''\\''] str}\\'"'';
  exts = es: map ext es;
in
{
  programs.emacs = {
    enable = true;
    init = {
      enable = true;
      recommendedGcSettings = true;
      postlude = ''
        (windmove-default-keybindings)

        (global-set-key [(control backspace)] 'kill-this-buffer)
        (global-set-key [(meta l)] 'goto-line)
        (global-set-key [(meta c)] 'comment-region)
        (global-set-key [(meta u)] 'uncomment-region)
        (global-unset-key (kbd "C-z"))

        (defalias 'yes-or-no-p 'y-or-n-p)
        (setq 'confirm-kill-emacs (quote y-or-n-p))

        (setq inhibit-startup-message t)
        (setq initial-scratch-message nil)
        (setq ring-bell-function 'ignore)

        (set-face-attribute 'default nil :family "Source Code Pro" :height 130 :weight 'normal :width 'normal)

        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        (menu-bar-mode -1)

        (line-number-mode)
        (column-number-mode)

        (setq-default show-trailing-whitespace t)

        (setq make-backup-files nil)

        ;; Delete whole line + newline on C-k at start of line
        (setq kill-whole-line t)
        ;; Indent with spaces only, not tabs
        (setq-default indent-tabs-mode nil)
        ;; Tab indents 4 spaces unless overridden by other modes/files
        (setq-default tab-width 4)
        ;; Show matching paren always, immediately
        (setq show-paren-mode t)
        (setq show-paren-delay 0)
        ;; Prefer UTF-8 as much as possible.
        (set-default-coding-systems 'utf-8)

        ;; Use shell-script-mode to edit redo and redoconf files
        (add-to-list 'auto-mode-alist '("\\.do$" . shell-script-mode))
        (add-to-list 'auto-mode-alist '("\\.od$" . shell-script-mode))
      '';
      usePackage = {
        ansi-color = pkg {
          command = ["ansi-color-apply-on-region"];
        };
        autorevert = pkg {
          diminish = ["auto-revert-mode"];
          config = "(global-auto-revert-mode)";
        };
        base16-theme = pkg {
          config = "(load-theme 'base16-solarized-dark t)";
        };
        beacon = pkg {
          diminish = ["beacon-mode"];
          config = "(beacon-mode 1)";
        };
        direnv = pkg {
          config = "(direnv-mode)";
        };
        exec-path-from-shell = pkg {
          config = ''
            (setq 'exec-path-from-shell-variables (quote ("PATH" "MANPATH" "GOPATH")))
          '';
        };
        vertico = pkg {
          # bind = {
          #   #"RET" = "vertico-directory-enter";
          #   #"DEL" = "vertico-directory-delete-word";
          #   #"M-d" = "vertico-directory-delete-char";
          # };
          config = ''
            (vertico-mode t)
            (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
            (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-word)
            (define-key vertico-map (kbd "M-d") #'vertico-directory-delete-char)
          '';
        };
        consult = pkg {
          # bind = {
          #   #"[rebind switch-to-buffer]" = "consult-buffer";
          #   "C-x b" = "consult-buffer";
          #   "C-c j" = "consult-line";
          #   "C-c i" = "consult-imenu";
          # };
          config = ''
            (setq read-buffer-completion-ignore-case t
                  read-file-name-completion-ignore-case t
                  completion-ignore-case t)
            (global-set-key [rebind switch-to-buffer] #'consult-buffer)
            (global-set-key (kbd "C-c j") #'consult-line)
            (global-set-key (kbd "C-c i") #'consult-imenu)
          '';
        };
        eglot = pkg {
          hook = ["(prog-mode . eglot-ensure)"];
          config = ''
            (add-to-list 'eglot-server-programs
                         '(go-mode . ("${pkgs.gopls}/bin/gopls"))
                         '(nix-mode . ("${pkgs.rnix-lsp}/bin/rnix-lsp"))
                         '((js-mode typescript-mode) .
                             ("${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server" "--stdio")))
          '';
        };
        flycheck = pkg {
          diminish = ["flycheck-mode"];
          config = ''
            ;; Only check buffer when mode is enabled or buffer is saved.
            (setq flycheck-check-syntax-automatically '(mode-enabled save))
            ;; Enable flycheck in all eligible buffers.
            (global-flycheck-mode)
          '';
        };
        corfu = pkg {
          hook = ["prog-mode"];
        };
        magit = pkg {
          bind = {
            "C-c g" = "magic-status";
          };
          config = ''
            (setq magit-diff-refine-hunk t)
          '';
        };
        # ivy = pkg {
        #   diminish = ["ivy-mode"];
        #   config = ''
        #     (setq ivy-use-virtual-buffers t
        #           ivy-count-format "%d/%d "
        #           ivy-virtual-abbreviate 'full)
        #     (define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
        #     (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
        #     (ivy-mode 1)
        #   '';
        # };
        uniquify = pkg {};

        systemd = pkg {
          # Could attempt to defer this with mode settings, but the
          # mode matches for the systemd package include quite complex
          # regexes, so just eat the always-load time for now.
        };
        dockerfile-mode = pkg {};
        go-mode = pkg {
	        mode = exts [".go"];
          config = ''
            (setq gofmt-command "goimports")
            (add-hook 'before-save-hook 'gofmt-before-save)
          '';
	      };
        scad-mode = pkg {};
        graphviz-dot-mode = pkg {
          mode = exts [".dot"];
        };
        js = pkg {
          mode = exts [".js" ".json"];
          config = ''
            (setq js-indent-level 2)
          '';
        };
        json-mode = pkg {
          mode = exts [".json"];
        };
        markdown-mode = pkg {
          mode = exts [".md"];
        };
	      nix-mode = pkg {
	        mode = exts [".nix"];
	      };
        terraform-mode = pkg {};
        protobuf-mode = pkg {
          mode = exts [".proto" ".pb"];
        };
        python = pkg {
          mode = ["(${ext ".py"} . python-mode)"];
        };
        rust-mode = pkg {
          mode = exts [".rs"];
        };
        web-mode = pkg {
          mode = exts [".html" ".htm"];
        };
        yaml-mode = pkg {
          mode = exts [".yaml"];
        };
        lua-mode = pkg {};
        slime = pkg {
          config = ''
            (setq slime-lisp-implementations
              '((sbcl ("sbcl" "--core" "${fastSwank}")
                      :init (lambda (port-file _)
                                    (format "(swank:start-server %S)\n" port-file)))))
          '';
        };
        bsv-mode = pkg {
          package = bsvPkg;
          mode = exts [".bsv"];
          config = ''
            (defun turn-off-indent-tabs-mode () (setq indent-tabs-mode nil))
            (add-hook 'bsv-mode-hook #'turn-off-indent-tabs-mode)
          '';
        };
      };
    };
  };
}
