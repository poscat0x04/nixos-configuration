;;; init-ui.el --- Theme and modeline -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

(use-package doom-themes
  :config
  (load-theme 'doom-nord-light t)
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(provide 'init-ui)

;;; init-ui.el ends here
