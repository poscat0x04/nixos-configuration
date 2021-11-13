
;; Code:

;; show trailing whitespaces
(use-package whitespace
  :hook ((prog-mode markdown-mode org-mode conf-mode) . whitespace-mode)
  :custom
  (whitespace-style '(face trailing)))

;; Tips for next keystroke
(use-package which-key
  :diminish which-key-mode
  :hook (after-init . which-key-mode)
  :custom (which-key-idle-delay 0.5))

;; The blazing grep tool
(use-package rg
  :defer t)

;; fuzzy search
(use-package fzf
  :defer t)

;; ivy core
(use-package ivy
  :diminish "ⓘ"
  :bind (("C-c C-r" . ivy-resume))
  :hook (after-init . ivy-mode)
  :custom
  (ivy-use-virtual-buffers 'recentf)
  (ivy-count-format "curent: %d; total: %d | ")
  (ivy-display-style 'fancy)
  (ivy-height 10)
  (ivy-fixed-height-minibuffer t)
  )

(use-package ivy-hydra
  :after ivy)

(use-package ivy-rich
    :after all-the-icons-ivy-rich
    :hook (ivy-mode . ivy-rich-mode)
    :custom
    (ivy-rich-parse-remote-buffer nil)
    )

(use-package all-the-icons-ivy-rich
  :custom
  (all-the-icons-ivy-rich-icon-size 0.90)
  :config
  (all-the-icons-ivy-rich-mode 1)
  )

(use-package amx)

;; fuzzy matcher
(use-package counsel
  :after amx
  :diminish "ⓒ"
  :hook (ivy-mode . counsel-mode)
  :bind (("M-s M-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("C-c v p" . ivy-push-view)
         ("C-c v o" . ivy-pop-view)
         ("C-c v ." . ivy-switch-view)
         ("M-y" . counsel-yank-pop)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . counsel-ibuffer))
  :custom
  (counsel-find-file-ignore-regexp "\\(?:\\`\\(?:\\.\\|__\\)\\|elc\\|pyc$\\)"))

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

;; Lint tool
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

;; switch windows quickly
(use-package ace-window
  :preface
  (defun my/switch-window ()
    (interactive)
    (if (<= (count-windows) 2)
        (other-window 1)
      (ace-window 1)))
  :bind (:map global-map
         ("M-o" . my/switch-window))
  :config
  (set-face-attribute
   'aw-leading-char-face nil
   :foreground "deep sky blue"
   :weight 'bold
   :height 3.0)
  (set-face-attribute
   'aw-mode-line-face nil
   :inherit 'mode-line-buffer-id
   :foreground "lawn green")
  (setq aw-keys '(?a ?s ?d ?f ?h ?j ?k ?l)
        aw-scope 'frame
        aw-dispatch-always t
        aw-dispatch-alist '((?x aw-delete-window "Ace - Delete Window")
                            (?c aw-swap-window "Ace - Swap Window")
                            (?n aw-flip-window)
                            (?v aw-split-window-vert "Ace - Split Vert Window")
                            (?h aw-split-window-horz "Ace - Split Horz Window")
                            (?m delete-other-windows "Ace - Maximize Window")
                            (?g delete-other-windows)
                            (?b balance-windows)
                            (?u (lambda ()
                                  (progn
                                    (winner-undo)
                                    (setq this-command 'winner-undo))))
                            (?r winner-redo))))

;; The markdown mode is awesome! unbeatable
(use-package markdown-mode
  :custom
  (markdown-command "pandoc")
  (markdown-fontify-code-blocks-natively t)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; beautiful term mode & friends
(use-package vterm
  :hook (vterm-mode . (lambda ()
                         (setq-local evil-insert-state-cursor 'box)
                         (setq-local evil-default-state 'insert)
                         (make-variable-buffer-local 'global-hl-line-mode)
                         (setq global-hl-line-mode nil)
                         (set (make-local-variable 'buffer-face-mode-face)
                              '(:family "Consolas" :height 110))
                         (buffer-face-mode)
                         )
                    )
  )

(use-package vterm-toggle
  :bind (:map global-map
         ("M-=" . vterm-toggle))
  :custom
  (vterm-toggle-fullscreen-p nil)
  :config
  (add-to-list 'display-buffer-alist
               '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3)
                 (reusable-frames . visible)
                 ))
  )

;; write documentation comment with in a easy way
(use-package separedit
  :custom
  (separedit-default-mode 'markdown-mode)
  (sparedit-remove-trailing-spaces-in-comment t)
  :bind (:map prog-mode-map
          ("C-c '" . separedit)))

;; pastebin service
(use-package webpaste
  :commands webpaste-paste-buffer-or-region
  :init
  (add-hook 'webpaste-return-url-hook
            (lambda (url)
              (message "Opened URL in chromium: %S" url)
              (browse-url-chromium-incognito url)))
  :custom
  (webpaste-paste-confirmation t)
  (webpaste-add-to-killring nil)
  (webpaste-provider-priority '("paste.mozilla.org" "dpaste.org" "ix.io")))

;; GC optimization
(use-package gcmh
  :custom
  (gcmh-high-cons-threshold 100000000)
  (gcmh-idle-delay 300)
  :hook (after-init . gcmh-mode))

;; Highlight TODO
(use-package hl-todo
  :hook (after-init . global-hl-todo-mode)
  :bind (:map hl-todo-mode-map
         ("C-c t p" . hl-todo-previous)
         ("C-c t n" . hl-todo-next)
         ("C-c t i" . hl-todo-insert)
         ("C-c t o" . hl-todo-occur)))

(provide 'init-tools)

;;; init-tools.el ends here
