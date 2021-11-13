
;;; Code:

;; Colorize parenthesises
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package toml-mode)
(use-package yaml-mode
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; Syntax highlighting for systemd files
(use-package conf-mode
  :mode ((rx "."
             (or "automount" "busname" "link" "mount" "netdev" "network"
                 "path" "service" "slice" "socket" "swap" "target" "timer")
             string-end) . conf-toml-mode))

;; Direnv
(use-package direnv
  :hook
  (after-init . direnv-mode))

(require 'init-nix)

(provide 'init-dev)

;;; init-dev.el ends here
