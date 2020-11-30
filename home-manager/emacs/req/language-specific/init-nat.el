
;;; Code:

(use-package flycheck-aspell
  :init (add-to-list 'flycheck-checkers 'tex-aspell-dynamic)
  :custom
  (ispell-dictionary "english.alias")
  (ispell-program-name "aspell")
  (ispell-silently-savep t))

(provide 'init-nat)

;;; init-nat.el ends here
