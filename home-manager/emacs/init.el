;;; init.el --- The main entry for emacs -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; A big contributor to startup times is garbage collection. We up the gc
;; threshold to temporarily prevent it from running, and then reset it by the
;; `gcmh' package.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(unless (or (daemonp) noninteractive)
  ;; Keep a ref to the actual file-name-handler
  (let ((default-file-name-handler-alist file-name-handler-alist))
    ;; Set the file-name-handler to nil (because regexing is cpu intensive)
    (setq file-name-handler-alist nil)
    ;; Reset file-name-handler-alist after initialization
    (add-hook 'emacs-startup-hook
              (lambda ()
                (setq file-name-handler-alist default-file-name-handler-alist)))))

;; Increase how much is read from processes in a single chunk (default is 4kb).
;; `lsp-mode' benefits from that.
(setq read-process-output-max (* 1024 1024))

(require 'package)
(add-to-list 'package-archives
	           '("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))

;; Emacs 27 introduces a quickstart mechanism which concatenate autoloads of all
;; packages to reduce the IO time.
;;
;; Don't forget to M-x package-quickstart-refresh if a new package is installed.
(setq package-quickstart t)

(package-initialize)

(require 'use-package)

(setq debug-on-error t)
(setq-default lexical-binding t)

(add-to-list 'load-path (expand-file-name "req/language-specific" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "req" user-emacs-directory))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

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

(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)

;;; init.el ends here
