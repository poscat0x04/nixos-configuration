
;;; Code:

(use-package purescript-mode)

(use-package psci
  :hook (purescript-mode . inferior-psci-mode))

(use-package psc-ide
  :hook
  (purescript-mode . (lambda ()
                       (psc-ide-mode)
                       (turn-on-purescript-indentation))))

(provide 'init-purs)

;;; init-purs.el ends here
