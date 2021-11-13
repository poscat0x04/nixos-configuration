
;;; Code:

(use-package evil
  :hook (after-init . evil-mode)
  ;; Don't quit Emacs on `:q'.
  ;;
  ;; Rebind `f'/`s' to mimic `evil-snipe'.
  :bind (([remap evil-quit] . kill-this-buffer)
         :map evil-motion-state-map
         ("f" . evil-avy-goto-char-in-line)
         :map evil-normal-state-map
         ("s" . evil-avy-goto-char-timer))
  :custom
  (evil-disable-insert-state-bindings t)
  (evil-want-Y-yank-to-eol t)
  ;; undo will never freeze my Emacs
  (evil-undo-system 'undo-redo)
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
  (evil-symbol-word-search t)
  :config
  ;; set leader key in normal state
  (evil-set-leader 'normal (kbd "SPC"))
  ;; set local leader
  (evil-set-leader 'normal "," t)
  (defun define-leader-key (state map localleader &rest bindings)
    "Define leader key in MAP when STATE, a wrapper for
`evil-define-key*'. All BINDINGS are prefixed with \"<leader>\"
if LOCALLEADER is nil, otherwise \"<localleader>\"."
    (cl-assert (cl-evenp (length bindings)))
    (let ((prefix (if localleader "<localleader>" "<leader>")))
      (while bindings
        (let ((key (pop bindings))
              (def (pop bindings)))
          (evil-define-key* state map (kbd (concat prefix key)) def)))))
  (define-leader-key 'normal 'global nil
    ;; project
    "p" 'projectile-command-map

    ;; org-mode
    "ol" 'org-store-link
    "oc" 'org-capture
  )
  (with-eval-after-load 'org
    (define-leader-key 'normal org-mode-map nil
      ; Navigation
      "." 'org-goto
      "j" 'org-next-visible-heading
      "k" 'org-previous-visible-heading
      "n" 'org-forward-heading-same-level
      "m" 'org-backward-heading-same-level
      "u" 'org-backward-heading-same-level

      ; Lists
      "i" 'org-insert-item

      ; Todo
      "t" 'org-todo
      "c" 'org-toggle-checkbox
      "T" 'org-show-todo-tree

      ; Archiving
      "a" 'org-toggle-archive-tag

      ; Misc
      "h" 'org-insert-subheading
      "l" 'org-lint
      "v" 'org-toggle-latex-fragment
      "op" 'org-toggle-ordered-property
      ";" 'org-toggle-comment
      "p" 'org-set-property
      "q" 'org-set-tags-command
      "r" 'org-refile
      "s" 'org-schedule
    )
  )
)

(use-package evil-collection
  :hook (evil-mode . evil-collection-init)
  :custom
  (evil-collection-calendar-want-org-bindings t)
  (evil-collection-outline-bind-tab-p nil)
  (evil-collection-setup-debugger-keys nil))

(use-package evil-surround
  :hook (prog-mode . evil-surround-mode))

(provide 'init-evil)

;;; init-evil.el ends here
