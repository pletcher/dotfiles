;;; init.el --- emacs config
;;
;; Copyright (c) 2019 Charles Pletcher
;; borrowing liberally from https://github.com/bbatsov/emacs.d

;; Author: Charles Pletcher <pletcher@protonmail.com>
;; URL: https://github.com/pletcher/emacs.d

;;; Commentary:
;;
;; I have no idea what I'm doing.

;;; License:

;;; Code:

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(package-initialize)

(unless package-archive-contents
	(package-refresh-contents))

(setq user-full-name "Charles Pletcher"
			user-mail-address "pletcher@protonmail.com")

(setq load-prefer-newer t)

(defconst my-savefile-dir (expand-file-name "savefile" user-emacs-directory))

(unless (file-exists-p my-savefile-dir)
	(make-directory my-savefile-dir))

(when (fboundp 'tool-bar-mode)
	(tool-bar-mode -1))

(setq ring-bell-function 'ignore)

(setq inhibit-startup-screen t)

(setq scroll-margin 0
			scroll-conservatively 10000
			scroll-preserver-screen-position 1)

(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default indent-line-function 'insert-tab)
(setq-default cursor-type 'bar)

(setq require-final-newline t)

(delete-selection-mode t)
(show-paren-mode 1)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(add-to-list 'default-frame-alist
						 '(font . "InputMonoNarrow light 9"))
(set-frame-font "InputMonoNarrow light 9")

(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

(global-set-key (kbd "RET") 'newline-and-indent)

(setq tab-always-indent 'complete)

(global-hl-line-mode +1)

(menu-bar-mode -1)

(eval-when-compile
	(unless (package-installed-p 'use-package)
		(package-install 'use-package)))

(require 'use-package)

(setq use-package-always-ensure t)
(setq use-package-verbose t)

(use-package nord-theme
  :config
  (load-theme 'nord t)
  (setq nord-comment-brightness 15)
  (setq nord-region-highlight "snowstorm"))

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package counsel
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x))

(use-package dired
  :ensure f
  :config
  (put 'dired-find-alternate-file 'disabled nil)
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)
  (setq dired-listing-switches "-lXGgh"))

(use-package easy-kill
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill))

(use-package ivy
  :config
  (ivy-mode 1))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package diff-hl
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode))

(use-package projectile
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (projectile-mode 1))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-use-paredit-bindings)
  (show-smartparens-global-mode +1)
  (smartparens-global-mode 1)
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET"))))

(use-package swiper
  :config
  (global-set-key (kbd "C-s") 'swiper))

(use-package whitespace
  :config
  (setq whitespace-line-column 100)
  (setq whitespace-style '(face tabs empty trailing lines-tail))
  (add-hook 'prog-mode-hook #'whitespace-mode)
  (add-hook 'before-save-hook #'whitespace-cleanup))

;;;
;; programming language modes start here
;;;

(use-package clojure-mode
  :config
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode))

(use-package cider
  :config
  (setq nrepl-log-messages t)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package elixir-mode
  :config
  (add-hook 'elixir-mode #'subword-mode))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package graphql-mode)

(use-package js2-mode
  :config
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode)))

(use-package json-mode)

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(use-package nim-mode
  :hook nimsuggest-mode)

(use-package olivetti)

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :hook visual-line-mode-hook)

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package rjsx-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode)))

(use-package ruby-mode
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (add-hook 'ruby-mode-hook #'subword-mode))

(use-package typescript-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.ts[x]?\\'" . typescript-mode)))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(use-package web-mode
  :custom
  (web-mode-code-indent-offset 2 "set code offset to 2 spaces")
  (web-mode-css-indent-offset 2 "set css offset to 2 spaces")
  (web-mode-markup-indent-offset 2 "set markup offset to 2 spaces")
  :config
  (add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (setq web-mode-content-types-alist '("jsx" . "\\.js[x]?\\'")))

(use-package writegood-mode
  :config
  (global-set-key "\C-cg" 'writegood-mode)
  (global-set-key "\C-c\C-gg" 'writegood-grade-level)
  (global-set-key "\C-c\C-ge" 'writegood-reading-ease))

(use-package yaml-mode)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bf390ecb203806cbe351b966a88fc3036f3ff68cd2547db6ee3676e87327b311" default)))
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (markdown-mode rainbow-delimiters json-mode graphql-mode elixir-mode editorconfig easy-kill f tide writegood-mode company yaml-mode diff-hl web-mode rjsx-mode olivetti nim-mode cider clojure-mode smartparens paredit projectile counsel magit nord-theme use-package)))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
