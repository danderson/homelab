{ pkgs, ...}:
let em = pkgs.emacsPackagesFor pkgs.emacs;
    bsv-mode = em.trivialBuild {
      pname = "bsv-mode";
      vwersion = "0.0";
      src = pkgs.fetchFromGitHub {
        owner = "danderson";
        repo = "bsv-mode";
        rev = "dd526198472c977a2350aefb0594da322b14e5f9";
        sha256 = "sha256-QcgDivhRKaiWNvSIH/0rKQvxprEN6N+bAxyp9iCcmiM=";
      };
    };
in
{
  programs.emacs = {
    enable = true;
    init = {
      enable = true;
      recommendedGcSettings = true;
      prelude = ''
        (add-to-list 'load-path "${bsv-mode}/share/emacs/site-lisp")
      '';
      postlude = ''
        (windmove-default-keybindings)

        (global-set-key [(control backspace)] 'kill-this-buffer)
        (global-set-key [(meta l)] 'goto-line)
        (global-set-key [(meta c)] 'comment-region)
        (global-set-key [(meta u)] 'uncomment-region)

        (setq 'confirm-kill-emacs (quote y-or-n-p))
        (setq 'exec-path-from-shell-variables (quote ("PATH" "MANPATH" "GOPATH")))

        (setq inhibit-startup-message t)
        (setq initial-scratch-message nil)

        (defalias 'yes-or-no-p 'y-or-n-p)
        (set-face-attribute 'default nil :family "Source Code Pro" :height 130 :weight 'normal :width 'normal)

        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        (menu-bar-mode -1)

        (line-number-mode)
        (column-number-mode)

        (setq-default show-trailing-whitespace t)

        (setq make-backup-files nil)

        (setq kill-whole-line t)
        (setq indent-tabs-mode nil)
        (setq-default tab-width 4)
        (setq tramp-default-method "sshx")
        (setq show-paren-mode t)
        (setq show-paren-delay 0)

        (prefer-coding-system 'utf-8)
        (transient-mark-mode 1)

        (add-to-list 'auto-mode-alist '("\\.do$" . shell-script-mode))
        (add-to-list 'auto-mode-alist '("\\.od$" . shell-script-mode))

        (autoload 'bsv-mode "bsv-mode" "BSV mode" t )
        (add-to-list 'auto-mode-alist '("\\.bsv\\'" . bsv-mode))

        (defun turn-off-indent-tabs-mode ()
          (setq indent-tabs-mode nil))
        (add-hook 'bsv-mode-hook #'turn-off-indent-tabs-mode)
      '';
      usePackage = {
        scad-mode.enable = true;
        ansi-color = {
          enable = true;
          command = [ "ansi-color-apply-on-region" ];
        };
        autorevert = {
          enable = true;
          diminish = [ "auto-revert-mode" ];
          command = [ "auto-revert-mode" ];
          config = "(global-auto-revert-mode)";
        };
        base16-theme = {
          enable = true;
          config = "(load-theme 'base16-solarized-dark t)";
        };
        beacon = {
          enable = true;
          command = [ "beacon-mode" ];
          diminish = [ "beacon-mode" ];
          defer = 1;
          config = "(beacon-mode 1)";
        };
        direnv = {
          enable = true;
          config = "(direnv-mode)";
        };
        dockerfile-mode = {
          enable = true;
          mode = [ ''"Dockerfile\\'"'' ];
        };
        exec-path-from-shell = {
          enable = true;
        };
        flycheck = {
          enable = true;
          diminish = [ "flycheck-mode" ];
          command = [ "global-flycheck-mode" ];
          defer = 1;
          config = ''
            ;; Only check buffer when mode is enabled or buffer is saved.
            (setq flycheck-check-syntax-automatically '(mode-enabled save))
            ;; Enable flycheck in all eligible buffers.
            (global-flycheck-mode)
          '';
        };
        go-mode = {
	        enable = true;
	        mode = [''"\\.go\\'"''];
          config = ''
            (setq gofmt-command "goimports")
            (add-hook 'before-save-hook 'gofmt-before-save)
          '';
	      };
        graphviz-dot-mode = {
          enable = true;
          mode = [''"\\.dot\\'"''];
          config = ''
            (setq gofmt-command "goimports")
          '';
        };
        ivy = {
          enable = true;
          demand = true;
          diminish = [ "ivy-mode" ];
          command = [ "ivy-mode" ];
          config = ''
            (setq ivy-use-virtual-buffers t
                  ivy-count-format "%d/%d "
                  ivy-virtual-abbreviate 'full)
            (define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
            (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
            (ivy-mode 1)
          '';
        };
        js = {
          enable = true;
          mode = [
            ''("\\.js\\'" . js-mode)''
            ''("\\.json\\'" . js-mode)''
          ];
          config = ''
            (setq js-indent-level 2)
          '';
        };
        json-mode = {
          enable = true;
          mode = [''"\\.json\\'"''];
        };
        markdown-mode = {
          enable = true;
          mode = [''"\\.md\\'"''];
        };
	      nix-mode = {
	        enable = true;
	        mode = [''"\\.nix\\'"''];
	      };
        protobuf-mode = {
          enable = true;
          mode = [
            ''"\\.proto\\'"''
            ''"\\.pb\\'"''
          ];
        };
        python = {
          enable = true;
          mode = [ ''("\\.py\\'" . python-mode)'' ];
        };
        rust-mode = {
          enable = true;
          mode = [''"\\.rs\\'"''];
        };
        systemd = {
          enable = true;
          defer = true;
        };
        uniquify = {
          enable = true;
        };
        web-mode = {
          enable = true;
          mode = [
            ''"\\.html\\'"''
            ''"\\.htm\\'"''
          ];
        };
        yaml-mode = {
          enable = true;
          mode = [''"\\.yaml\\'"''];
        };
      };
    };
  };
}
