;;; init.el --- The main entry for emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Defer GC
(setq gc-cons-threshold 100000000)

(require 'package)
(add-to-list 'package-archives
	           '("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))

(package-initialize)

(require 'use-package)

(setq debug-on-error nil)

(add-to-list 'load-path (expand-file-name "req/language-specific" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "req" user-emacs-directory))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

(require 'init-generic)
(require 'init-evil)
(require 'init-lsp)
(require 'init-org)
(require 'init-git)
(require 'init-ui)
(require 'init-snippet)
(require 'init-startup)
(require 'init-tools)
(require 'init-dev)

(provide 'init)

;;; init.el ends here
