
;;; Code:

(use-package nix-mode
  :mode "\\.nix\\'")
(use-package nix-company
    :commands nix-company
    :hook (nix-mode . (lambda ()
                        (setq-local company-backends '(nix-company)))))

(provide 'init-nix)

;;; init-ats.el ends here
