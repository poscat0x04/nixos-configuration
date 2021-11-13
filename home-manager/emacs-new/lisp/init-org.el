;;; init-org.el --- Org mode configurations -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-cdlatex-mode)
         )
  :config
  (plist-put org-format-latex-options :scale 2.0)
  :custom
  (org-directory "~/.org/")
  (org-default-notes-file (expand-file-name "notes.org" org-directory))
  ;; prettify
  (org-startup-indented t)
  (org-fontify-todo-headline t)
  (org-fontify-done-headline t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-hide-emphasis-markers t)
  ;; image
  (org-image-actual-width nil)
  (org-display-remote-inline-images 'cache)
  ;; latex
  (org-preview-latex-image-directory "~/.cache/org/")
  ;; more user-friendly
  (org-imenu-depth 4)
  (org-clone-delete-id t)
  (org-use-sub-superscripts '{})
  (org-yank-adjusted-subtrees t)
  (org-ctrl-k-protect-subtree 'error)
  (org-catch-invisible-edits 'smart)
  (org-insert-heading-respect-content t)
  ;; call C-c C-o explicitly
  (org-return-follows-link nil)
  ;; Remove CLOSED: [timestamp] after switching to non-DONE states
  (org-closed-keep-when-no-todo t)
  ;; log
  (org-log-repeat 'time)
  (org-log-into-drawer t)
  ;; refile
  (org-refile-use-cache nil)
  (org-refile-targets '((org-agenda-files . (:maxlevel . 6))))
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (org-refile-allow-creating-parent-nodes 'confirm)
  ;; goto. We use minibuffer to filter instead of isearch.
  (org-goto-auto-isearch nil)
  (org-goto-interface 'outline-path-completion)
  ;; tags, e.g. #+TAGS: keyword in your file
  (org-use-tag-inheritance nil)
  (org-agenda-use-tag-inheritance nil)
  (org-use-fast-tag-selection t)
  (org-fast-tag-selection-single-key t)
  ;; archive
  (org-archive-location "%s_archive::datetree/")
  ;; id
  (org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
  ;; abbreviation for url
  (org-link-abbrev-alist '(("GitHub" . "https://github.com/")
                           ("GitLab" . "https://gitlab.com/")
                           ("Google" . "https://google.com/search?q=")
                           ("RFCs"   . "https://tools.ietf.org/html/"))))

;; Write codes in org-mode
(use-package org-src
  :hook (org-babel-after-execute . org-redisplay-inline-images)
  :bind (:map org-src-mode-map
         ;; consistent with separedit/magit
         ("C-c C-c" . org-edit-src-exit))
  :custom
  (org-confirm-babel-evaluate nil)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-src-window-setup 'other-window)
  (org-src-lang-modes '(("C"      . c)
                        ("python" . python)
                        ("elisp"  . emacs-lisp)
                        ("bash"   . sh)
                        ("shell"  . sh)
                        ("tex" . LaTeX)
                        ("latex" . LaTeX)))
  (org-babel-load-languages '((C          . t)
                              (python     . t)
                              (emacs-lisp . t)
                              (latex      . t)
                              (shell      . t))))


(provide 'init-org)

;;; init-org.el ends here
