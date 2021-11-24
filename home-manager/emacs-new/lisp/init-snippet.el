
;;; Code:
(use-package yasnippet-snippets)

(use-package yasnippet
  :init (yas-global-mode)
  :bind (:map yas-minor-mode-map
         ("C-j" . yas-expand))
  :custom
  (yas-snippet-dirs (cons "~/.config/emacs/snippets" yas-snippet-dirs)))


(provide 'init-snippet)

;;; init-snippet.el ends here
