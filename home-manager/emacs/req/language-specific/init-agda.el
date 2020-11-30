
;;; Code:

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(setq agda2-program-args '("--local-interfaces"))

(defun next-slide-please ()
  (interactive)
  (search-forward "{---")
  (next-line)
  (recenter-top-bottom 0)
)

(defun previous-slide-please ()
  (interactive)
  (search-backward "{---")
  (previous-line)
  (search-backward "{---")
  (next-line)
  (recenter-top-bottom 0)
)

(defun comment-in-agda ()
  (interactive)
  (search-forward "{-+}")
  (backward-delete-char 2)
  (insert "(-}")
  (search-forward "{+-}")
  (backward-delete-char 3)
  (insert "-)-}")
  (search-backward "{-(-}")
  (next-line)
  (agda2-load)
)

(defun comment-out-agda ()
  (interactive)
  (search-backward "{-(-}")
  (forward-char 4)
  (backward-delete-char 2)
  (insert "+")
  (search-forward "-)-}")
  (backward-delete-char 4)
  (insert "+-}")
  (next-line)
  (agda2-load)
)

(add-hook 'agda2-mode-hook (lambda () (global-set-key "`" 'next-slide-please)
                                      (global-set-key "~" 'previous-slide-please)
                                      (global-set-key [?\C-`] 'comment-in-agda)
                                      (global-set-key [?\M-`] 'comment-out-agda)))

(provide 'init-agda)

;;; init-agda.el ends here
