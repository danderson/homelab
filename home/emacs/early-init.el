;;; early-init.el --- early init
;;; Commentary:
;;; Code:

;; Reduce garbage collection frequency during startup and minibuffer
;; use.
(defun my/reduce-gc ()
  "Reduce garbage collection rate."
  (setq gc-cons-threshold most-positive-fixnum
        gc-cons-percentage 0.6))

(defun my/restore-gc ()
  "Reset GC rate to normal."
  (setq gc-cons-threshold 16777216
        gc-cons-percentage 0.1))

(my/reduce-gc)
(add-hook 'emacs-startup-hook #'my/restore-gc)
(add-hook 'minibuffer-setup-hook #'my/reduce-gc -50)
(add-hook 'minibuffer-exit-hook #'my/restore-gc)
(add-hook 'kill-emacs-hook #'my/reduce-gc -50)

;; Turn off regexp file matching while loading config.
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook (lambda ()
                                (setq file-name-handler-alist my/file-name-handler-alist)
                                (makunbound 'my/file-name-handler-alist)))

;; Don't let menubars and other UI features try to resize the emacs
;; window. I use a tiling WM, so the resize attempt will fail anyway.
;; And leaving this on slows down startup when font sizes and other
;; things are changed, because emacs will try in vain to resize the
;; window to preserve the number of visible rows and columns.
(setq frame-inhibit-implied-resize t)

;; TODO: figure out package-quickstart, not sure how to properly meld
;; nix-derived packages with aftermarket installs.
;(setq package-quickstart t
;      package-quickstart-file "package-quickstart.el")

;; Make the GUI things go away before they have a chance to be
;; displayed.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen t
      use-file-dialog nil)

(provide 'early-init)
;;; early-init.el ends here
