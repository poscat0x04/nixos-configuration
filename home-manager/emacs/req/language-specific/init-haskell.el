;;; init-haskell.el --- Haskell -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:
(use-package haskell-mode
  :hook
  (haskel-mode . haskell-indentation-mode)
  :init
  (unless (fboundp 'align-rules-list)
    (defvar align-rules-list nil))
  (add-to-list 'align-rules-list
               '(haskell-types
                 (regexp . "\\(\\s-+\\)\\(::\\|∷\\)\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  (add-to-list 'align-rules-list
               '(haskell-assignment
                 (regexp . "\\(\\s-+\\)=\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  (add-to-list 'align-rules-list
               '(haskell-arrows
                 (regexp . "\\(\\s-+\\)\\(->\\|→\\)\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  (add-to-list 'align-rules-list
               '(haskell-left-arrows
                 (regexp . "\\(\\s-+\\)\\(<-\\|←\\)\\s-+")
                 (modes quote (haskell-mode literate-haskell-mode))))
  :bind (("C-x a a" . align)
         :map haskell-mode-map
         ("C-c h" . hoogle)
         ("C-o"   . open-line)
         ("C-c C-c" . haskell-compile)
         :map haskell-cabal-mode-map
         ("C-c h" . hoogle)
         ("C-c C-c" . haskell-compile))
  :custom
    (haskell-compile-cabal-build-command "stack build --ghc-options=-Wall")
    (haskell-compile-command "ghc -dynamic -Wall -ferror-spans -fforce-recomp -c %s")
    (haskell-process-suggest-haskell-docs-imports t)
    (haskell-process-suggest-remove-import-lines  t)
    (haskell-process-log                          t)
    (haskell-process-suggest-hoogle-imports       t)
    (haskell-tags-on-save                         t)
    (inhibit-startup-screen                       t))

(use-package lsp-haskell
  :hook (haskell-mode . lsp)
  :custom
  (lsp-haskell-process-path-hie "haskell-language-server"))

;(use-package flycheck-haskell
;  :hook (haskell-mode . flycheck-haskell-setup))

(use-package haskell-snippets)

(use-package ormolu
 :hook (haskell-mode . ormolu-format-on-save-mode)
 :bind
 (:map haskell-mode-map
   ("C-c r" . ormolu-format-buffer)))

(provide 'init-haskell)

;;; init-haskell.el ends here
