;;; init-ui.el --- Theme and modeline -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

;; Themes
(use-package doom-themes
  :custom
  (doom-themes-treemacs-theme "doom-colors")
  :config
  (load-theme 'doom-nord-light t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package recentf
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 300)
  (recentf-auto-cleanup 'never)
  (recentf-exclude '((expand-file-name package-user-dir)
                     ".cache"
                     "cache"
                     "recentf"
                     "^/tmp/"
                     "/ssh:"
                     "/su\\(do\\)?:"
                     "^/nix/store/"
                     "COMMIT_EDITMSG\\'"))
  :preface
  (defun my/recentf-save-list-silence ()
    (interactive)
    (let ((message-log-max nil))
      (if (fboundp 'shut-up)
          (shut-up (recentf-save-list))
        (recentf-save-list)))
    (message ""))
  (defun my/recentf-cleanup-silence ()
    (interactive)
    (let ((message-log-max nil))
      (if (fboundp 'shut-up)
          (shut-up (recentf-cleanup))
        (recentf-cleanup)))
    (message ""))
  :hook
  (focus-out-hook . (my/recentf-save-list-silence my/recentf-cleanup-silence)))

(use-package page-break-lines
  :defer t)

;; All `temp-buffer's, e.g. *Completions*, will never mess up window layout.
(use-package help
  :hook (after-init . temp-buffer-resize-mode)
  :custom
  (help-window-select t))

(use-package dashboard
  :diminish
  (dashboard-mode page-break-lines-mode)
  :hook (after-init . dashboard-setup-startup-hook)
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-init-info t)
  (dashboard-set-navigator t)
  (dashboard-items '((recents . 10)
                     (projects . 5)
                     (bookmarks . 5))))

;; Fonts
;;;  Default Fonts
(set-face-attribute 'default nil
                    :height 120
                    :font "Consolas")
;;;  Fallback Fonts
(set-fontset-font t nil (font-spec :height 120 :name "Noto Sans Mono"))

; Tweaks

;; Supress GUI features and more
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-x-resources t
      inhibit-default-init t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t)

;; Pixelwise resize
(setq window-resize-pixelwise t
      frame-resize-pixelwise t)

;; Linux specific
(setq x-gtk-use-system-tooltips nil
      x-underline-at-descent-line t)

;; Optimize for very long lines
(setq bidi-paragraph-direction 'left-to-right
      bidi-inhibit-bpa t)

;; Flash status bar
(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  "Flashes the modeline, intended to replace the ring bell function"
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))

;; No eyes distraction
(setq blink-cursor-mode nil)

;; Smooth scroll & friends
(setq scroll-step 2
      scroll-margin 2
      hscroll-step 2
      hscroll-margin 2
      scroll-conservatively 101
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      scroll-preserve-screen-position 'always)

;; The nano style for truncated long lines.
(setq auto-hscroll-mode 'current-line)

;; Disable auto vertical scroll for tall lines
(setq auto-window-vscroll nil)

;; Dont move points out of eyes
(setq mouse-yank-at-point t)

(setq-default fill-column 120)

;; A simple frame title
(setq frame-title-format '("%b - Emacs")
      icon-title-format frame-title-format)


(provide 'init-ui)

;;; init-ui.el ends here
