;;; init.el --- init
;;; Commentary:
;;; Code:

;; Activate use-package and the things it needs. use-package is installed by
;; emacs.nix, and the other two libs are bundled with emacs.
(require 'use-package)
(require 'diminish)
(require 'bind-key)

(use-package ansi-color
    :commands (ansi-color-apply-on-region))

(use-package autorevert
    :diminish (auto-revert=mode)
    :config (global-auto-revert-mode))

(provide 'init)
;;; init.el ends here
