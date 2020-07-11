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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is free and unencumbered software released into the public domain. ;;
;;                                                                         ;;
;; Anyone is free to copy, modify, publish, use, compile, sell, or         ;;
;; distribute this software, either in source code form or as a compiled   ;;
;; binary, for any purpose, commercial or non-commercial, and by any       ;;
;; means.                                                                  ;;
;;                                                                         ;;
;; In jurisdictions that recognize copyright laws, the author or authors   ;;
;; of this software dedicate any and all copyright interest in the         ;;
;; software to the public domain. We make this dedication for the benefit  ;;
;; of the public at large and to the detriment of our heirs and            ;;
;; successors. We intend this dedication to be an overt act of             ;;
;; relinquishment in perpetuity of all present and future rights to this   ;;
;; software under copyright law.                                           ;;
;;                                                                         ;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         ;;
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      ;;
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  ;;
;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR       ;;
;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ;;
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR   ;;
;; OTHER DEALINGS IN THE SOFTWARE.                                         ;;
;;                                                                         ;;
;; For more information, please refer to <http://unlicense.org>            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(package-initialize)

(unless package-archive-contents
	(package-refresh-contents))

(setq user-full-name "Charles Pletcher"
      user-mail-address "c@plet.ch")

(setq load-prefer-newer t)

(defconst my-savefile-dir (expand-file-name "savefile" user-emacs-directory))

(unless (file-exists-p my-savefile-dir)
	(make-directory my-savefile-dir))

(when (fboundp 'tool-bar-mode)
	(tool-bar-mode -1))

(setq ring-bell-function 'ignore)

(setq inhibit-startup-screen t)

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
(global-display-line-numbers-mode '1)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")

(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-x \\") #'align-regexp)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

(global-set-key (kbd "RET") 'newline-and-indent)

(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq scroll-step 1)
(setq tab-always-indent 'complete)

;; enable using left Alt for diacritics
(setq mac-command-modifier 'meta
      mac-option-modifier 'none
      default-input-method "MacOSX")

(global-hl-line-mode +1)

(menu-bar-mode -1)
(scroll-bar-mode -1)

(set-frame-font "Iosevka Term" nil t)
(set-frame-parameter (selected-frame) 'alpha '(98 . 90))

(add-to-list 'default-frame-alist '(alpha . (98 . 90)))

(global-set-key (kbd "C-c q") 'auto-fill-mode)

(eval-when-compile
	(unless (package-installed-p 'use-package)
		(package-install 'use-package)))

(require 'use-package)

(setq use-package-always-ensure t)
(setq use-package-verbose t)

;; (load-theme 'ayu t)

(use-package doom-themes
  :after (neotree)
  :defines (doom-themes-enable-bold doom-themes-enable-italic doom-vibrant-brighter-modeline)
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-vibrant t)
  ;; (load-theme 'doom-Iosvkem t)
  ;; (doom-themes-org-config)
  (doom-themes-neotree-config)
  (setq doom-vibrant-brighter-modeline t))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; (use-package apropospriate-theme
;;   :config
;;   (load-theme 'apropospriate-dark t))

;; (use-package leuven-theme
;;   :defines (org-fontify-whole-heading-line)
;;   :init
;;   (setq org-fontify-whole-heading-line t)
;;   :config
;;   (load-theme 'leuven t))

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
  :init
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)
  (setq dired-listing-switches "-algh")
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil)))

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
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode))

(use-package paredit
  :hook ((cider-repl-mode
          emacs-lisp-mode
          lisp-interaction-mode
          lisp-mode
          eval-expression-minibuffer-setup) . paredit-mode))

(use-package projectile
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(use-package projectile-rails
  :defines (projectile-rails-mode-map projectile-rails-command-map)
  :config
  (define-key projectile-rails-mode-map (kbd "C-c r") 'projectile-rails-command-map)
  (projectile-rails-global-mode))

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

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package whitespace
  :config
  (setq whitespace-line-column 200)
  (setq whitespace-style '(face empty trailing lines-tail))
  :hook ((prog-mode . whitespace-mode)
         (before-save . whitespace-cleanup)))

;;;
;; programming language modes start here
;;;

(use-package add-node-modules-path)

(use-package all-the-icons)

(use-package cider)

(use-package clojure-mode
  :commands subword-mode)

(use-package coffee-mode)

(use-package ebib
  :init
  (global-set-key "\C-cb" 'ebib)
  (setq ebib-autogenerate-keys nil)
  (setq ebib-bibtex-dialect 'biblatex)
  (setq ebib-notes-directory "~/writing/notes/")
  (setq ebib-preload-bib-files '("~/writing/references.bib")))

(use-package editorconfig
  :hook (prog-mode . editorconfig-mode))

(use-package elixir-mode
  :commands subword-mode)

(use-package emmet-mode
  :init
  (setq emmet-expand-jsx-className? t)
  (setq emmet-self-closing-tag-style " /"))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-inline
  :requires flycheck
  :commands flycheck-inline-mode)

(use-package flycheck-rust
  :requires flycheck
  :defer t)

(use-package graphql-mode
  :defer t)

(use-package haml-mode
  :defer t)

(use-package json-mode
  :defer t)

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(use-package multiple-cursors
  :config
  (require 'multiple-cursors)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this-word)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this-word)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this-dwim))

(use-package neotree)

(use-package nim-mode
  :hook nimsuggest-mode)

(use-package olivetti
  :defer t
  :config
  (setq olivetti-body-width 84))

(defun org-begin-end-quote ()
  "Insert an 'org-mode' quote block."
  (interactive)
  (insert "#+BEGIN_QUOTE")
  (newline)
  (newline)
  (insert "#+END_QUOTE")
  (newline)
  (forward-line -1)
  (forward-line -1))

(defun org-begin-end-verse ()
  "Insert an 'org-mode' verse block."
  (interactive)
  (insert "#+BEGIN_VERSE")
  (newline)
  (newline)
  (insert "#+END_VERSE")
  (newline)
  (forward-line -1)
  (forward-line -1))

(use-package org
  :ensure org-plus-contrib
  :defines (org-latex-bib-compiler
            org-latex-classes
            org-latex-compiler
            org-latex-pdf-process)
  :mode ("\\.org\\'" . org-mode)
  :hook (visual-line-mode-hook)
  :init
  (setq org-latex-bib-compiler "biber")
  (setq org-latex-compiler "xelatex")
  (setq org-latex-pdf-process '("xelatex -interaction nonstopmode -output-directory %o %f"
	"biber %b"
	"xelatex -interaction nonstopmode -output-directory %o %f"
	"xelatex -interaction nonstopmode -output-directory %o %f"))
  (setq org-startup-folded nil)
  :config
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))
  (define-key org-mode-map (kbd "C-c q") 'org-begin-end-quote)
  (define-key org-mode-map (kbd "C-c v") 'org-begin-end-verse))

(use-package org-noter)

(use-package org-ref
  :init
  (setq reftex-default-bibliography "~/writing/references.bib")
  (setq org-ref-default-bibliography '("~/writing/references.bib"))
  (setq org-ref-default-citation-link "autocite")
  (setq org-ref-insert-cite-key "C-c c")
  (setq org-ref-pdf-directory "~/Nextcloud/references")
  (setq bibtex-completion-bibliography "~/writing/references.bib")
  (require 'org-ref))

(use-package org-roam
  :defines (org-roam-completion-system org-roam-directory)
  :init
  (setq org-roam-completion-system 'ivy)
  (setq org-roam-directory "~/writing/notes")
  (add-hook 'after-init-hook 'org-roam-mode))

(use-package ox-reveal
  :defines (org-reveal-root)
  :init
  (setq org-reveal-root "file:///home/pletcher/code/reveal.js"))

(use-package pandoc-mode
  :hook (markdown-mode-hook))

(use-package pdf-tools
  :config
  (custom-set-variables '(pdf-tools-handle-upgrades nil))
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))

(pdf-tools-install)

(use-package prettier-js
  :hook (web-mode . prettier-js-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rjsx-mode
  :mode ("\\.js\\'" . rjsx-mode))

(use-package robe
  :init (add-hook 'ruby-mode-hook 'robe-mode))

(use-package ruby-mode
  :init
  (setq ruby-insert-encoding-magic-comment nil)
  :commands subword-mode)

(use-package rust-mode
  :init
  (setq rust-format-on-save t)
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

(use-package tex-site
  :ensure auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :init
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-cite-format 'biblatex)
  ;; (setq LaTeX-reftex-cite-format-auto-activate t)
  (setq-default TeX-engine 'xetex)
  :hook (LaTeX-mode . reftex-mode))

(use-package typescript-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.ts[x]?\\'" . typescript-mode)))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(use-package web-mode
  :requires add-node-modules-path
  :commands add-node-modules-path
  :init
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-attr-value-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  ;; :config
  ;; (defadvice web-mode-highlight-part (around tweak-jsx activate)
  ;;   (if (equal web-mode-content-type "jsx")
  ;;       (let ((web-mode-enable-part-face nil))
  ;;         ad-do-it)
  ;;     ad-do-it))
  )

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
 '(ansi-color-names-vector
   ["#424242" "#EF9A9A" "#C5E1A5" "#FFEE58" "#64B5F6" "#E1BEE7" "#80DEEA" "#E0E0E0"])
 '(beacon-color "#eab4484b8035")
 '(custom-safe-themes
   (quote
    ("54472f6db535c18d72ca876a97ec4a575b5b51d7a3c1b384293b28f1708f961a" "bf390ecb203806cbe351b966a88fc3036f3ff68cd2547db6ee3676e87327b311" default)))
 '(ebib-notes-template "* %T
:PROPERTIES:
%K
:END:
>|<
")
 '(fill-column 80)
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-symbol-colors
   (quote
    ("#FFEE58" "#C5E1A5" "#80DEEA" "#64B5F6" "#E1BEE7" "#FFCC80")))
 '(highlight-symbol-foreground-color "#E0E0E0")
 '(highlight-tail-colors (quote (("#eab4484b8035" . 0) ("#424242" . 100))))
 '(js-indent-level 2)
 '(org-noter-notes-search-path (quote ("~/writing/notes/")))
 '(package-selected-packages
   (quote
    (org-roam coffee-mode projectile-rails org-plus-contrib doom-modeline haml-mode helm-mode org-bullets neotree all-the-icons robe org-noter exec-path-from-shell indium rjsx-mode bundler ox-reveal org-reveal pandoc-mode evil-leader evil undo-tree autofill-mode auto-fill-mode nlinum sublimity add-node-modules-path ebib writegood-mode emmet-mode telephone-line apropospriate-theme prettier-js flycheck-rust flycheck-inline rust-mode tex-site auctex org-ref slime xresources-theme markdown-mode rainbow-delimiters json-mode graphql-mode elixir-mode editorconfig easy-kill f tide company yaml-mode diff-hl web-mode olivetti nim-mode cider clojure-mode smartparens paredit projectile counsel magit use-package)))
 '(pdf-tools-handle-upgrades nil)
 '(pos-tip-background-color "#3a513a513a51")
 '(pos-tip-foreground-color "#9E9E9E")
 '(tabbar-background-color "#353335333533"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(variable-pitch ((t (:height 1.2 :family "Sans Serif")))))
