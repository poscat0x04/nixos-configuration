;;; init-evil.el --- Bring vim back -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

(require 'init-macros)

(use-package evil
  :init
  (setq evil-disable-insert-state-bindings t)
  (setq evil-want-Y-yank-to-eol t)
  :hook (after-init . evil-mode)
  ;; Don't quit Emacs on `:q'.
  ;;
  ;; Rebind `f'/`s' to mimic `evil-snipe'.
  :bind (([remap evil-quit] . kill-this-buffer)
         :map evil-motion-state-map
         ("f" . evil-avy-goto-char-in-line)
         :map evil-normal-state-map
         ("s" . evil-avy-goto-char-timer))
  :config
  ;; Silence line out of range error.
  (shut-up! #'evil-indent)
  :custom
  ;; undo will never freeze my Emacs
  (evil-undo-system (if (>= emacs-major-version 28) 'undo-redo 'undo-fu))
  ;; Switch to the new window after splitting
  (evil-split-window-below t)
  (evil-vsplit-window-right t)
  (evil-ex-complete-emacs-commands nil)
  (evil-ex-interactive-search-highlight 'selected-window)
  ;; when `visual-line-mode' enabled, exchange j/k with gj/gk
  (evil-respect-visual-line-mode t)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-fine-undo t)
  (evil-want-C-g-bindings t)
  (evil-want-abbrev-expand-on-insert-exit nil)
  (evil-symbol-word-search t))

(use-package evil-collection
  :disabled
  :hook (evil-mode . evil-collection-init)
  :custom
  (evil-collection-calendar-want-org-bindings t)
  (evil-collection-outline-bind-tab-p nil)
  (evil-collection-setup-debugger-keys nil))

(use-package evil-leader
  :custom (evil-leader/leader "<SPC>")
  :config
  (global-evil-leader-mode)
  (evil-leader/set-key
    "f" 'find-file-at-point)
  )

(use-package evil-nerd-commenter
  :config
  (global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines))

(use-package evil-surround
  :hook (prog-mode . evil-surround-mode))

(provide 'init-evil)

;;; init-evil.el ends here
