;;; init-dev.el --- Programming development -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

;; Compilation Mode
(use-package compile
  :preface
  ;; ANSI Coloring
  ;; @see https://stackoverflow.com/questions/13397737/ansi-coloring-in-compilation-mode
  (defun my-colorize-compilation-buffer ()
    "ANSI coloring in compilation buffers."
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  :hook (compilation-filter . my-colorize-compilation-buffer)
  :custom
  (compilation-scroll-output t))

;; highlight TODO
(use-package hl-todo
  :bind (:map hl-todo-mode-map
              ([C-f3] . hl-todo-occur)
              ("C-c t p" . hl-todo-previous)
              ("C-c t n" . hl-todo-next)
              ("C-c t o" . hl-todo-occur))
  :hook (after-init . global-hl-todo-mode)
  :config
  (dolist (keyword '("BUG" "ISSUE" "FIXME" "XXX" "NOTE" "NB"))
    (cl-pushnew `(,keyword . ,(face-foreground 'error)) hl-todo-keyword-faces))
  (dolist (keyword '("WORKAROUND" "HACK" "TRICK"))
    (cl-pushnew `(,keyword . ,(face-foreground 'warning)) hl-todo-keyword-faces)))

;; show trailing whitespaces
(use-package whitespace
  :hook ((prog-mode markdown-mode conf-mode) . whitespace-mode)
  :config
  (setq whitespace-style '(face trailing)))

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
  :bind (:map projectile-mode-map
         ("C-c p" . projectile-command-map))
  :hook (prog-mode . projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  (projectile-indexing-method 'hybrid)
  (projectile-read-command nil) ;; no prompt in projectile-compile-project
  :config
  ;; project side rg
  (use-package ripgrep)

  ;; cmake project build
  (projectile-register-project-type 'cmake '("CMakeLists.txt")
                                    :configure "cmake %s"
                                    :compile "cmake --build Debug"
                                    :test "ctest")

  (let ((ig-dirs '(".ccls"
                   ".ccls-cache"
                   ".clangd"
                   "bazel-bin"
                   "bazel-out"
                   "bazel-testlogs")))
    (dolist (dir ig-dirs)
      (push dir projectile-globally-ignored-directories)))
  )

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
  :config
  (setq flycheck-indication-mode 'right-fringe)
  (setq-default flycheck-disabled-checkers '(c/c++-clang
                                             c/c++-cppcheck
                                             c/c++-gcc
                                             haskell-stack-ghc))
  )

;; xref
(use-package ivy-xref
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package toml-mode)
(use-package yaml-mode)
(use-package pkgbuild-mode)
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

(require 'init-rust)
(require 'init-haskell)
(require 'init-agda)
(require 'init-coq)
(require 'init-latex)
(require 'init-nat)
(require 'init-nix)

(provide 'init-dev)

;;; init-dev.el ends here
