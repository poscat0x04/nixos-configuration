;;; init-tools.el --- We all like productive tools -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

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

;; Jump to arbitrary positions
(use-package avy
  :custom
  (avy-timeout-seconds 0.2)
  (avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?q ?w ?e ?r ?u ?i ?o ?p))
  :config
  ;; evil-leader keybindings
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "w" 'avy-goto-word-or-subword-1
      "e" 'avy-goto-end-of-line
      "s" 'avy-goto-char-timer
      "l" 'avy-goto-line))
  )

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

(use-package all-the-icons-ivy-rich
  :custom
  (all-the-icons-ivy-rich-icon-size 0.80)
  :config
  (all-the-icons-ivy-rich-mode 1)
  )

(use-package ivy-rich
    :after (ivy all-the-icons-ivy-rich)
    :hook (ivy-mode . ivy-rich-mode)
    :custom
    (ivy-rich-parse-remote-buffer nil)
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

;; DONT use swiper
(use-package isearch
  :custom
  (lazy-highlight-cleanup nil))

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
                         (buffer-face-mode)))
  )

(use-package vterm-toggle
  :bind (:map global-map
         ("M-=" . vterm-toggle)
         :map vterm-mode-map
         ("<C-return>" . vterm-toggle-insert-cd))
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3)
                 (reusable-frames . visible)
                 ))
  )

;; GC optimization
(use-package gcmh
  :custom
  (gcmh-high-cons-threshold 100000000)
  (gcmh-idle-delay 300)
  :hook (after-init . gcmh-mode))

;; required by `comment-edit'
(use-package dash)

;; required by `comment-edit'
(use-package edit-indirect)

;; write documentation comment with in a easy way
(use-package separedit
  :custom
  (separedit-default-mode 'markdown-mode)
  (sparedit-remove-trailing-spaces-in-comment t)
  :bind (:map prog-mode-map
          ("C-c '" . separedit)))

;; pastebin service
(use-package webpaste
  :custom
  (webpaste-paste-confirmation t)
  (webpaste-add-to-killring nil)
  (webpaste-provider-priority '("dpaste.org" "dpaste.com" "ix.io"))
  :config
  (add-hook 'webpaste-return-url-hook
            (lambda (url)
              (message "Opened URL in browser: %s" url)
              (browse-url url)))
  )

;; Edit text for browser with GhostText or AtomicChrome extension
(use-package atomic-chrome
  :hook ((emacs-startup . atomic-chrome-start-server)
         (atomic-chrome-edit-mode . delete-other-windows))
  :custom
  (atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-default-major-mode 'markdown-mode)
  :config
  (if (fboundp 'gfm-mode)
      (setq atomic-chrome-url-major-mode-alist
            '(("github\\.com" . gfm-mode)))))

;; grip-mode
(use-package grip-mode
  :hook ((markdown-mode org-mode) . grip-mode)
  :custom
  (grip-preview-use-webkit t))

(provide 'init-tools)

;;; init-tools.el ends here
