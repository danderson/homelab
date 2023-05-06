;;; init.el --- init
;;; Commentary:
;;; Code:

;; Activate use-package and the things it needs. use-package is installed by
;; emacs.nix, and the other two libs are bundled with emacs.
(require 'use-package)
(require 'diminish)
(require 'bind-key)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq kill-whole-line t ; C-k at line start deletes entire line+newline
      ; Show matching parentheses, without delay.
      show-paren-mode t
      show-parent-delay 0
      ; Don't make backup files, I have ZFS and version control.
      make-backup-files nil
      auto-save-default nil
      ; Don't lock files either, editing collisions don't matter to me.
      create-lockfiles nil
      ; Make sure you want to kill emacs.
      confirm-kill-emacs 'y-or-n-p
      ; Nothing the in scratch buffer to start with.
      initial-scratch-message nil
      ; Never make a noise, you're not Twitter.
      ring-bell-function 'ignore
      ; Make tab indent if not already indented, otherwise autocomplete
      tab-always-indent 'complete)
(setq-default indent-tabs-mode nil
              tab-width 4
              show-trailing-whitespace t)

;; Prefer UTF-8 as much as possible.
(set-default-coding-systems 'utf-8)

;; Show line and column numbers in the mode line.
(line-number-mode)
(column-number-mode)

;; Enable shift+arrow keys to navigate between frames.
(windmove-default-keybindings)

;; Set a pleasant font, slightly larger.
(set-face-attribute 'default nil :family "Source Code Pro" :height 130 :weight 'normal :width 'normal)

;; Use shell-script-mode to edit redo and redoconf files
(add-to-list 'auto-mode-alist '("\\.do$" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.od$" . sh-mode))

;; Quick chord to close a file.
(global-set-key [(control backspace)] 'kill-this-buffer)
;; Quick way to navigate to a line.
(global-set-key [(meta l)] 'goto-line)
;; Quick comment/uncomment.
(global-set-key [(meta c)] 'comment-region)
(global-set-key [(meta u)] 'uncomment-region)

;; C-z suspends emacs and basically breaks it.
;; I never want to break emacs. Stop it.
(global-unset-key (kbd "C-z"))

;;;;;;;;;;;;;;;;;;;;;;;
;; "Functionality" packages that alter the entire emacs experience in
;; some way.
;;;;;;;;;;;;;;;;;;;;;;;

(use-package base16-theme
  :config (load-theme 'base16-solarized-dark t))

;; Automatically revert a buffer when it changes on disk.
(use-package autorevert
  :ensure nil ; builtin
  :diminish (auto-revert-mode)
  :config
  (global-auto-revert-mode)
  (setq auto-revert-verbose nil))

;; Attract the eye to cursor position on events like buffer switching
;; where it's not obvious where the cursor is.
(use-package beacon
  :diminish (beacon-mode)
  :config (beacon-mode 1))

;; Make unique, useful buffer names for files that have the same name
;; in different directories.
(use-package uniquify
  :ensure nil) ; builtin

(use-package vertico
  :config
  (vertico-mode t)
  (setq vertico-count 20
        read-extended-command-predicate #'command-completion-default-include-p
        enable-recursive-minibuffers t)
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (keymap-set vertico-map "DEL" #'vertico-directory-delete-char)
  (keymap-set vertico-map "M-DEL" #'vertico-directory-delete-word))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package savehist
  :ensure nil ; builtin
  :init (savehist-mode))

(use-package recentf
  :ensure nil ; builtin
  :bind ("C-x C-r" . consult-recent-file)
  :init (recentf-mode)
  :config
  (setq recentf-max-menu-items 25)
  (setq recentf-max-saved-items 25)
  (run-at-time nil (* 5 60) 'recentf-save-list))

; TODO: all-the-icons and all-the-icons-completion

(use-package consult
  :bind
  ("C-x b" . consult-buffer)
  ("C-c m" . consult-man)
  ("M-g f" . consult-flycheck)
  ("M-g e" . consult-compile-error)
  ("M-l" . consult-goto-line)
  ("M-s g" . consult-git-grep)
  ("M-s r" . consult-ripgrep)
  ("M-s l" . consult-line)
  ("M-s L" . consult-line-multi))

(use-package consult-flycheck
  :commands (consult-flycheck))

(use-package corfu
  :init (global-corfu-mode))

(use-package exec-path-from-shell)

(use-package eglot
  :ensure nil
  :hook (prog-mode . eglot-ensure))

(use-package flycheck
  :diminish (flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save))
  (global-flycheck-mode))

(use-package eldoc
  :ensure nil ; builtin
  :diminish (eldoc-mode))

(use-package magit
  :bind (("C-x g" . magit-status))
  :config (setq magit-diff-refine-hunk t))

;;;;;;;;;;;;;;;;;;;;;;;
;; A whole bunch of major modes for different files.
;;;;;;;;;;;;;;;;;;;;;;;

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package go-mode
  :mode "\\.go\\'"
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package graphviz-dot-mode
  :mode "\\.dot\\'")

(use-package js
  :ensure nil ; builtin
  :mode "\\.js\\'"
  :mode "\\.json\\'"
  :config (setq js-indent-level 2))

(use-package json-mode
  :mode "\\.json\\'")

(use-package lua-mode)

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package protobuf-mode
  :mode "\\.proto\\'"
  :mode "\\.pb\\'")

(use-package python
  :ensure nil ; builtin
  :mode ("\\.py\\'" . python-ts-mode))

(use-package rust-mode
  :mode ("\\.rs\\'"))

(use-package scad-mode)

(use-package slime) ; TODO: preloaded SBCL

(use-package systemd)

(use-package terraform-mode
  :mode "\\.tf\\'")

(use-package web-mode
  :mode "\\.html\\'"
  :mode "\\.htm\\'")

(use-package yaml-mode
  :mode "\\.yaml\\'")

;; Needs to be loaded late, so that direnv stuff gets set _early_ in a
;; mode's startup (it installs its hooks last, which puts them at the
;; start of the hook list).
(use-package envrc
  :diminish (envrc-mode)
  :config (envrc-global-mode))

(when (file-exists-p "~/.emacs.d/local.el")
  (load-file "~/.emacs.d/local.el"))

(provide 'init)
;;; init.el ends here
