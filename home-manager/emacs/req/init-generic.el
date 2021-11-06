;;; init-generic.el --- The necessary settings -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:
;; Supress GUI features
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-startup-screen t
      inhibit-startup-message t)

;; No backup files
(setq make-backup-files nil
      auto-save-default nil)

;; Flash status bar
(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

;; Disable cursor blink
(blink-cursor-mode (- (*) (*) (*)))

;; smooth scroll & friends
(setq scroll-step 2
      scroll-margin 2
      hscroll-step 2
      hscroll-margin 2
      scroll-conservatively 10000
      scroll-preserve-screen-position 'always)

;; Newline behaviour
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "S-<return>") 'comment-indent-new-line)


;; DONT move points out of eyes
(setq mouse-yank-at-point t)

(setq-default fill-column 80)

(setq adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*")
(setq adaptive-fill-first-line-regexp "^* *$")

;; Paragraphs
(setq sentence-end "\\([。、！？]\\|……\\|[,.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)

;; Treats the `_' as a word constituent
(add-hook 'after-change-major-mode-hook
          (lambda ()
            (modify-syntax-entry ?_ "w")))

;; No tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; font
(set-face-attribute 'default nil :height 120)
(set-face-attribute 'default nil :font "consolas")
;(set-face-attribute 'default nil :font "DejaVu Sans Mono")
(set-fontset-font "fontset-default" '(#x2200 . #x2200) (font-spec :height 120 :name "DejaVu Sans Mono"))

;; Prefer shorter names
(fset 'yes-or-no-p 'y-or-n-p)

(defalias 'list-buffers 'ibuffer)

;; Keep clean
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))

;; Highlight parenthesises
(use-package paren
  :hook (after-init . show-paren-mode)
  :config
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))

;; The selected region of text can be deleted
(use-package delsel
  :hook (after-init . delete-selection-mode))

;; show line/column number
(use-package simple
  :hook (after-init . (lambda ()
                        (line-number-mode)
                        (column-number-mode)
                        (size-indication-mode))))

;; save cursor position
(use-package saveplace
  :hook (after-init . save-place-mode))

;; highlight current line
(use-package hl-line
  :hook (after-init . global-hl-line-mode))

;(use-package server
;  :ensure nil
;  :hook (after-init . server-mode))

;; Try out emacs package without installing
(use-package try)

;; Browser
(defun browse-url-chromium-incognito (url &optional new-window)
  "open url in chromium with incognito mode"
  (shell-command
     (concat "chromium --incognito --app=" url)))

(setq browse-url-browser-function 'browse-url-chromium-incognito)

;; separate clipboard and kill-ring
(setq save-interprogram-paste-before-kill nil)


(provide 'init-generic)

;;; init-generic.el ends here
