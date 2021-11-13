;;; Code:

(use-package tex
  :defer t
  :hook
  (LaTeX-mode . visual-line-mode)
  (LaTeX-mode . LaTeX-math-mode)
  :custom
  (preview-scale-function 3)
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-method 'synctex)
  (TeX-view-program-selection
    (quote (((output-dvi style-pstricks) "dvips and gv")
            (output-dvi "zathura")
            (output-pdf "zathura")
            (output-html "xdg-open"))))
  :config
  (setq-default TeX-master nil
                TeX-engine 'xetex))

(use-package company-auctex
  :init
  (company-auctex-init))

(use-package auctex-latexmk
  :init
  (auctex-latexmk-setup)
  :custom
  (auctex-latexmk-inherit-TeX-PDF-mode t))

(use-package cdlatex
  :hook (LaTeX-mode . cdlatex-mode))

(provide 'init-latex)

;;; init-latex.el ends here
