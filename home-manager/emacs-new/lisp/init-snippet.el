
;;; Code:
(use-package yasnippet-snippets)

(use-package yasnippet
  :init (yas-global-mode)
  :bind (:map yas-minor-mode-map
         ("C-j" . yas-expand)))


(provide 'init-snippet)

;;; init-snippet.el ends here
