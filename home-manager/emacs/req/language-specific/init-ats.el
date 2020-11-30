
;;; Code:

(require 'ats-mode "ats2-mode")
(require 'ats2-flycheck "flycheck-ats2")
(add-hook 'ats-mode-hook (lambda () (flycheck-mode 1)
                                    (flycheck-select-checker 'ats2)))

(provide 'init-ats)

;;; init-ats.el ends here
