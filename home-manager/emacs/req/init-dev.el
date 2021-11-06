;;; init-dev.el --- Programming development -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

;; Compilation Mode
(use-package compile
  :hook (compilation-filter . my-colorize-compilation-buffer)
  :config
  (defun colorize-compilation-buffer ()
    "ANSI coloring in compilation buffers."
    (with-silent-modifications
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  :custom
  (compilation-always-kill t)
  (compilation-scroll-output t)
  (compilation-ask-about-save nil))

;; highlight TODO
(use-package hl-todo
  :hook (after-init . global-hl-todo-mode)
  :bind (:map hl-todo-mode-map
              ([C-f3] . hl-todo-occur)
              ("C-c t p" . hl-todo-previous)
              ("C-c t n" . hl-todo-next)
              ("C-c t o" . hl-todo-occur)))

;; show trailing whitespaces
(use-package whitespace
  :hook ((prog-mode markdown-mode conf-mode) . whitespace-mode)
  :custom
  (whitespace-style '(face trailing)))

;; quickrun codes, including cpp. awesome!
(use-package quickrun
  :bind (("C-c x" . quickrun))
  :custom
  (quickrun-focus-p nil)
  (quickrun-input-file-extension ".qr"))

;; A tree layout file explorer
(use-package treemacs
  :commands (treemacs-follow-mode
             treemacs-filewatch-mode
             treemacs-fringe-indicator-mode
             treemacs-git-mode)
  :defines (treemacs-git-integration
            treemacs-change-root-without-asking
            treemacs-never-persist)
  :bind
  (:map global-map
        ([f8]        . treemacs)
        ("M-0"       . treemacs-select-window)
        ("C-c 1"     . treemacs-delete-other-windows))
  :config
  (setq treemacs-follow-after-init          t
        treemacs-width                      35
        treemacs-indentation                2
        treemacs-git-integration            t
        treemacs-collapse-dirs              3
        treemacs-silent-refresh             nil
        treemacs-change-root-without-asking nil
        treemacs-sorting                    'alphabetic-desc
        treemacs-show-hidden-files          t
        treemacs-never-persist              nil
        treemacs-is-never-other-window      nil
        treemacs-goto-tag-strategy          'refetch-index)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t))

;; project management
(use-package projectile
  :hook (after-init . projectile-mode)
  :bind (:map projectile-mode-map
         ("C-c p" . projectile-command-map))
  :custom
  (projectile-use-git-grep t)
  (projectile-completion-system 'ivy)
  (projectile-indexing-method 'hybrid)
  (projectile-read-command nil) ;; no prompt in projectile-compile-project
  (projectile-ignored-projects `("~/"
                                 "/tmp/"
                                 )))

(use-package treemacs-evil
  :after treemacs evil
  :config
  (evil-define-key 'treemacs treemacs-mode-map (kbd "l") 'treemacs-RET-action)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "h") 'treemacs-TAB-action))

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-magit
  :after treemacs magit)

;; lint tool
(use-package flycheck
  :diminish " FC"
  :hook
  (prog-mode . flycheck-mode)
  (text-mode . flycheck-mode)
  :custom
  (flycheck-temp-prefix ".flycheck")
  (flycheck-check-syntax-automatically '(save mode-enabled))
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-indication-mode 'right-fringe))

;; xref
(use-package xref
  :ensure nil
  :init
  ;; On Emacs 28, `xref-search-program' can be set to `ripgrep'.
  ;; `project-find-regexp' benefits from that.
  (when (>= emacs-major-version 28)
    (setq xref-search-program 'ripgrep)
    (setq xref-show-xrefs-function #'xref-show-definitions-completing-read)
    (setq xref-show-definitions-function #'xref-show-definitions-completing-read))
  :hook ((xref-after-return xref-after-jump) . recenter))

(use-package toml-mode)
(use-package yaml-mode
  :mode ("\\.ya?ml\\'" . yaml-mode))
(use-package dhall-mode
  :mode "\\.dhall\\'")

(use-package rainbow-delimiters
  :hook
  (emacs-lisp-mode . rainbow-delimiters-mode)
  (haskell-mode    . rainbow-delimiters-mode)
  (purescript-mode . rainbow-delimiters-mode)
  (idris-mode      . rainbow-delimiters-mode))

(use-package direnv
  :config
  (direnv-mode))

;; Syntax highlighting for systemd files
(use-package conf-mode
  :ensure nil
  :mode ((rx "."
             (or "automount" "busname" "link" "mount" "netdev" "network"
                 "path" "service" "slice" "socket" "swap" "target" "timer")
             string-end) . conf-toml-mode))

(require 'init-rust)
(require 'init-haskell)
(require 'init-agda)
(require 'init-coq)
(require 'init-latex)
(require 'init-nat)
(require 'init-nix)

(provide 'init-dev)

;;; init-dev.el ends here
