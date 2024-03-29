;;; init-startup.el --- The startup dashboard -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:


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
                     "^/usr/include/"
                     "^/nix/store/"
                     "bookmarks"
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

(provide 'init-startup)

;;; init-startup.el ends here
