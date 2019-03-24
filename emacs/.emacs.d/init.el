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
			scroll-preserve-screen-position 1)

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

;; (use-package nord-theme
;;   :config
;;   (load-theme 'nord t)
;;   (setq nord-comment-brightness 15)
;;   (setq nord-region-highlight "snowstorm"))

(use-package xresources-theme
  :config
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line          nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :underline  line)
    (set-face-attribute 'mode-line          nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :box        nil)
    (set-face-attribute 'mode-line-inactive nil :background nil)))

(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

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
  (setq dired-listing-switches "-algh"))

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
  (setq whitespace-style '(face empty trailing lines-tail))
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

(use-package emmet-mode
  :config
  (setq emmet-expand-jsx-className? t)
  (setq emmet-self-closing-tag-style " /"))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-inline
  :requires flycheck
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-inline-mode))

(use-package flycheck-rust
  :requires flycheck
  :config
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package graphql-mode)

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

(use-package org-ref
  :config
  (setq reftex-default-bibliography '("~/Dropbox/bibliography/references.bib"))
  (setq org-ref-bibliography-notes "~/Dropbox/bibliography/notes.org")
  (setq org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib"))
  (setq org-ref-default-citation-link "autocite")
  (setq org-ref-insert-cite-key "C-c c")
  (setq org-ref-pdf-directory "~/Dropbox/bibliography/bibtex-pdfs")
  (setq bibtex-completion-bibliography "~/Dropbox/bibliography/references.bib")
  (require 'org-ref))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package ruby-mode
  :init
  (setq ruby-insert-encoding-magic-comment nil)
  :config
  (add-hook 'ruby-mode-hook #'subword-mode))

(use-package rust-mode
  :init
  (setq rust-format-on-save t))

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

(use-package tex-site
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :init
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-cite-format 'biblatex)
  (setq LaTeX-reftex-cite-format-auto-activate t)
  (setq-default TeX-engine 'xetex)
  :config
  (add-hook 'LaTeX-mode-hook 'reftex-mode))

(use-package typescript-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.ts[x]?\\'" . typescript-mode)))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(use-package web-mode
  :init
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  :config
  (add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil))
          ad-do-it)
      ad-do-it))
  (add-hook 'web-mode-hook (lambda ()
                             (setq web-mode-attr-indent-offset 2)
                             (setq web-mode-attr-value-indent-offset 2)
                             (setq web-mode-code-indent-offset 2)
                             (setq web-mode-css-indent-offset 2)
                             (setq web-mode-markup-indent-offset 2))))

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
    (moody flycheck-rust flycheck-inline rust-mode tex-site auctex org-ref emmet-mode slime xresources-theme markdown-mode rainbow-delimiters json-mode graphql-mode elixir-mode editorconfig easy-kill f tide writegood-mode company yaml-mode diff-hl web-mode olivetti nim-mode cider clojure-mode smartparens paredit projectile counsel magit nord-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
