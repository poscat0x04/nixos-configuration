
;;; Code:

(use-package idris-mode
  :custom
  (idris-interpreter-path "idris2"))

(idris-define-evil-keys)

(use-package helm-idris)

(provide 'init-idris)

;;; init-idris.el ends here
