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

(global-hl-line-mode +1)

(menu-bar-mode -1)
(scroll-bar-mode -1)

(set-frame-parameter (selected-frame) 'alpha '(98 . 90))

(add-to-list 'default-frame-alist '(alpha . (98 . 90)))

(global-set-key (kbd "C-c q") 'auto-fill-mode)

(eval-when-compile
	(unless (package-installed-p 'use-package)
		(package-install 'use-package)))

(require 'use-package)

(setq use-package-always-ensure t)
(setq use-package-verbose t)

(use-package apropospriate-theme
  :config
  (load-theme 'apropospriate-dark t))

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
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
   "b" 'switch-to-buffer
   "w" 'save-buffer))

(use-package evil
  :config
  (evil-mode t))

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

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package whitespace
  :config
  (setq whitespace-line-column 100)
  (setq whitespace-style '(face empty trailing lines-tail))
  :hook (prog-mode . whitespace-mode))

;;;
;; programming language modes start here
;;;

(use-package add-node-modules-path)

(use-package clojure-mode
  :commands subword-mode)

(use-package ebib
  :init
  (global-set-key "\C-cb" 'ebib)
  (setq ebib-autogenerate-keys nil)
  (setq ebib-bibtex-dialect 'biblatex)
  (setq ebib-notes-directory "~/Documents/writing/notes/")
  (setq ebib-preload-bib-files '("~/Documents/writing/references.bib")))

(use-package editorconfig
  :hook (prog-mode . editorconfig-mode))

(use-package elixir-mode
  :commands subword-mode)

(use-package emmet-mode
  :init
  (setq emmet-expand-jsx-className? t)
  (setq emmet-self-closing-tag-style " /"))

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

(use-package json-mode
  :defer t)

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(use-package nim-mode
  :hook nimsuggest-mode)

(use-package olivetti
  :defer t)

(use-package org
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
  (add-hook 'org-mode-hook (lambda () (olivetti-mode))))

(use-package org-ref
  :init
  (setq reftex-default-bibliography "~/Documents/writing/references.bib")
  (setq org-ref-default-bibliography '("~/Documents/writing/references.bib"))
  (setq org-ref-default-citation-link "autocite")
  (setq org-ref-insert-cite-key "C-c c")
  (setq org-ref-pdf-directory "~/Nextcloud/references")
  (setq bibtex-completion-bibliography "~/Documents/writing/references.bib")
  (require 'org-ref))

(use-package pandoc-mode
  :hook (markdown-mode-hook))

(use-package prettier-js
  :hook (web-mode . prettier-js-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

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
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  :config
  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil))
          ad-do-it)
      ad-do-it)))

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
 '(bibtex-align-at-equal-sign t)
 '(bibtex-autoadd-commas t)
 '(bibtex-contline-indentation 0)
 '(bibtex-entry-format
   (quote
    (opts-or-alts required-fields numerical-fields realign unify-case sort-fields)))
 '(bibtex-field-indentation 4)
 '(bibtex-style-indent-basic 0)
 '(bibtex-text-indentation 17)
 '(custom-safe-themes
   (quote
    ("bf390ecb203806cbe351b966a88fc3036f3ff68cd2547db6ee3676e87327b311" default)))
 '(fill-column 80)
 '(js-indent-level 2)
 '(olivetti-body-width 80)
 '(org-agenda-files (quote ("~/Nextcloud/Columbia/Fall 2019/agenda.org")))
 '(org-link-parameters
   (quote
    (("id" :follow org-id-open)
     ("rmail" :follow org-rmail-open :store org-rmail-store-link)
     ("mhe" :follow org-mhe-open :store org-mhe-store-link)
     ("irc" :follow org-irc-visit :store org-irc-store-link)
     ("info" :follow org-info-open :export org-info-export :store org-info-store-link)
     ("gnus" :follow org-gnus-open :store org-gnus-store-link)
     ("docview" :follow org-docview-open :export org-docview-export :store org-docview-store-link)
     ("bbdb" :follow org-bbdb-open :export org-bbdb-export :complete org-bbdb-complete-link :store org-bbdb-store-link)
     ("w3m" :store org-w3m-store-link)
     ("printindex" :follow org-ref-index :export
      #[(path desc format)
        "\301=\205	 \300\302!\207"
        [format latex "\\printindex"]
        2])
     ("index" :follow
      #[(path)
        "\301!\207"
        [path occur]
        2]
      :export
      #[(path desc format)
        "\302=\205
 \300\303	\"\207"
        [format path latex "\\index{%s}"]
        3])
     ("bibentry" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-bibentry :complete org-bibentry-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("autocites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-autocites :complete org-autocites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("supercites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-supercites :complete org-supercites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Textcites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Textcites :complete org-Textcites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("textcites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-textcites :complete org-textcites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Smartcites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Smartcites :complete org-Smartcites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("smartcites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-smartcites :complete org-smartcites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("footcitetexts" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-footcitetexts :complete org-footcitetexts-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("footcites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-footcites :complete org-footcites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Parencites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Parencites :complete org-Parencites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("parencites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-parencites :complete org-parencites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Cites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Cites :complete org-Cites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("cites" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-cites :complete org-cites-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("fnotecite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-fnotecite :complete org-fnotecite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Pnotecite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Pnotecite :complete org-Pnotecite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("pnotecite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-pnotecite :complete org-pnotecite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Notecite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Notecite :complete org-Notecite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("notecite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-notecite :complete org-notecite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("footfullcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-footfullcite :complete org-footfullcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("fullcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-fullcite :complete org-fullcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citeurl" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citeurl :complete org-citeurl-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citedate*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citedate* :complete org-citedate*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citedate" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citedate :complete org-citedate-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citetitle*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citetitle* :complete org-citetitle*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citetitle" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citetitle :complete org-citetitle-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Citeauthor*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Citeauthor* :complete org-Citeauthor*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("autocite*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-autocite* :complete org-autocite*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("autocite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-autocite :complete org-autocite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("supercite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-supercite :complete org-supercite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("parencite*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-parencite* :complete org-parencite*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("cite*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-cite* :complete org-cite*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Smartcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Smartcite :complete org-Smartcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("smartcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-smartcite :complete org-smartcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Textcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Textcite :complete org-Textcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("textcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-textcite :complete org-textcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("footcitetext" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-footcitetext :complete org-footcitetext-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("footcite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-footcite :complete org-footcite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Parencite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Parencite :complete org-Parencite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("parencite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-parencite :complete org-parencite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Cite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Cite :complete org-Cite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Citeauthor" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Citeauthor :complete org-Citeauthor-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Citealp" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Citealp :complete org-Citealp-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Citealt" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Citealt :complete org-Citealt-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Citep" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Citep :complete org-Citep-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("Citet" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-Citet :complete org-Citet-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citeyearpar" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citeyearpar :complete org-citeyearpar-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citeyear*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citeyear* :complete org-citeyear*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citeyear" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citeyear :complete org-citeyear-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citeauthor*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citeauthor* :complete org-citeauthor*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citeauthor" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citeauthor :complete org-citeauthor-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citetext" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citetext :complete org-citetext-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citenum" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citenum :complete org-citenum-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citealp*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citealp* :complete org-citealp*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citealp" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citealp :complete org-citealp-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citealt*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citealt* :complete org-citealt*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citealt" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citealt :complete org-citealt-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citep*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citep* :complete org-citep*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citep" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citep :complete org-citep-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citet*" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citet* :complete org-citet*-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("citet" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-citet :complete org-citet-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("nocite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-nocite :complete org-nocite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse)))
     ("cite" :follow
      (lambda
        (_)
        (funcall org-ref-cite-onclick-function nil))
      :export org-ref-format-cite :complete org-cite-complete-link :help-echo
      (lambda
        (window object position)
        (when org-ref-show-citation-on-enter
          (save-excursion
            (goto-char position)
            (let
                ((s
                  (org-ref-format-entry
                   (org-ref-get-bibtex-key-under-cursor))))
              (with-temp-buffer
                (insert s)
                (fill-paragraph)
                (buffer-string))))))
      :face org-ref-cite-link-face-fn :display full :keymap
      (keymap
       (tab lambda nil
            (interactive)
            (funcall org-ref-insert-cite-function))
       (S-up . org-ref-sort-citation-link)
       (S-right lambda nil
                (interactive)
                (org-ref-swap-citation-link 1))
       (S-left lambda nil
               (interactive)
               (org-ref-swap-citation-link -1))
       (C-right . org-ref-next-key)
       (C-left . org-ref-previous-key)
       (16777337 lambda nil "Paste key at point. Assumes the first thing in the killring is a key."
                 (interactive)
                 (org-ref-insert-key-at-point
                  (car kill-ring)))
       (16777303 lambda nil "Copy all the keys at point."
                 (interactive)
                 (kill-new
                  (org-element-property :path
                                        (org-element-context))))
       (16777335 lambda nil
                 (interactive)
                 (kill-new
                  (car
                   (org-ref-get-bibtex-key-and-file))))
       (16777318 lambda nil
                 (interactive)
                 (save-excursion
                   (org-ref-open-citation-at-point)
                   (kill-new
                    (org-ref-format-bibtex-entry-at-point))))
       (16777319 . org-ref-google-scholar-at-point)
       (16777317 lambda nil "Email entry at point"
                 (interactive)
                 (org-ref-open-citation-at-point)
                 (org-ref-email-bibtex-entry))
       (16777315 . org-ref-wos-citing-at-point)
       (16777330 . org-ref-wos-related-at-point)
       (16777326 . org-ref-open-notes-at-point)
       (16777328 . org-ref-open-pdf-at-point)
       (16777333 . org-ref-open-url-at-point)
       (16777314 . org-ref-open-citation-at-point)
       (16777327 . org-ref-cite-hydra/body)
       (follow-link . mouse-face)
       (mouse-3 . org-find-file-at-mouse)
       (mouse-2 . org-open-at-mouse))
      :store org-ref-bibtex-store-link)
     ("Cref" :follow org-ref-ref-follow :export org-ref-Cref-export :complete org-ref-complete-link :face org-ref-ref-face-fn :help-echo org-ref-ref-help-echo)
     ("cref" :follow org-ref-ref-follow :export org-ref-cref-export :complete org-ref-complete-link :face org-ref-ref-face-fn :help-echo org-ref-ref-help-echo)
     ("autoref" :follow org-ref-ref-follow :export org-ref-autoref-export :complete org-ref-complete-link :face org-ref-ref-face-fn :help-echo org-ref-ref-help-echo)
     ("eqref" :follow org-ref-ref-follow :export org-ref-eqref-export :complete org-ref-complete-link :face org-ref-ref-face-fn :help-echo org-ref-ref-help-echo)
     ("nameref" :follow org-ref-ref-follow :export org-ref-export-nameref :complete org-ref-complete-link :face org-ref-ref-face-fn :help-echo org-ref-ref-help-echo)
     ("pageref" :follow org-ref-ref-follow :export
      #[(path desc format)
        "\302=\203 \300\303	\"\207\304=\205 \300\305	\"\207"
        [format path html "(<pageref>%s</pageref>)" latex "\\pageref{%s}"]
        3]
      :face org-ref-ref-face-fn :complete org-pageref-complete-link :help-echo org-ref-ref-help-echo)
     ("ref" :follow org-ref-ref-follow :export org-ref-ref-export :complete org-ref-complete-link :face org-ref-ref-face-fn :help-echo org-ref-ref-help-echo)
     ("label" :follow
      #[(label)
        "\302!\303\304\305	\211\306U\204 	\307V\203 \310\202 \311#\302!\")\207"
        [label count org-ref-count-labels message format "%s occurence%s" 0 1 "s" ""]
        6 "On clicking count the number of label tags used in the buffer.
A number greater than one means multiple labels!"]
      :export
      #[(keyword desc format)
        "\302=\203 \300\303	\"\207\304=\203 \300\305	\"\207\306=\205  \300\307	\"\207"
        [format keyword html "<div id=\"%s\"></div>" md "<a name=\"%s\"></a>" latex "\\label{%s}"]
        3]
      :store org-label-store-link :face org-ref-label-face-fn :help-echo
      #[(window object position)
        "\212b\210\303 \304\305!r
q\210\306\216	c\210\307 \210\310 -\207"
        [position s temp-buffer org-ref-link-message generate-new-buffer " *temp*"
                  #[nil "\301!\205	 \302!\207"
                        [temp-buffer buffer-name kill-buffer]
                        2]
                  fill-paragraph buffer-string]
        2])
     ("list-of-tables" :follow org-ref-list-of-tables :export
      #[(keyword desc format)
        "\301=\205	 \300\302!\207"
        [format latex "\\listoftables"]
        2])
     ("list-of-figures" :follow org-ref-list-of-figures :export
      #[(keyword desc format)
        "\301=\205	 \300\302!\207"
        [format latex "\\listoffigures"]
        2])
     ("addbibresource" :follow org-ref-follow-addbibresource :export
      #[(keyword desc format)
        "\302=\203
 \300\303!\207\304=\205 \300\305	\"\207"
        [format keyword html "" latex "\\addbibresource{%s}"]
        3])
     ("bibliographystyle" :export
      #[(keyword desc format)
        "\302=\204 \303=\203 \300\304	\"\207\305\207"
        [format keyword latex beamer "\\bibliographystyle{%s}" ""]
        3])
     ("printbibliography" :follow org-ref-open-bibliography :export
      #[(keyword desc format)
        "\302=\203	 \303 \207\304=\203 \305 \207\306=\205 	\207"
        [format org-ref-printbibliography-cmd org org-ref-get-org-bibliography html org-ref-get-html-bibliography latex]
        2])
     ("nobibliography" :follow org-ref-open-bibliography :export org-ref-nobibliography-format)
     ("bibliography" :follow org-ref-open-bibliography :export org-ref-bibliography-format :complete org-bibliography-complete-link :help-echo
      #[(window object position)
        "\212b\210\303 \304\305!r
q\210\306\216	c\210\307 \210\310 -\207"
        [position s temp-buffer org-ref-link-message generate-new-buffer " *temp*"
                  #[nil "\301!\205	 \302!\207"
                        [temp-buffer buffer-name kill-buffer]
                        2]
                  fill-paragraph buffer-string]
        2]
      :face org-ref-bibliography-face-fn)
     ("Acp" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("Acp" . "Glspl")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("acp" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("acp" . "glspl")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("Ac" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("Ac" . "Gls")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("ac" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("ac" . "gls")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("acrfull" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("acrfull" . "acrfull")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("acrlong" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("acrlong" . "acrlong")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("acrshort" :follow or-follow-acronym :face org-ref-acronym-face :help-echo or-acronym-tooltip :export
      #[771 "\211\301=\203 \302\303\300A#\207\302\304\226\"\207"
            [("acrshort" . "acrshort")
             latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("glslink" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\300=\203 \301\302#\207\301\303\"\207"
            [latex format "\\glslink{%s}{%s}" "%s"]
            7 "

(fn PATH DESC FORMAT)"])
     ("glsdesc" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\301=\203 \302\303\300#\207\302\304\"\207"
            ["glsdesc" latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("glssymbol" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\301=\203 \302\303\300#\207\302\304\"\207"
            ["glssymbol" latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("Glspl" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\301=\203 \302\303\300#\207\302\304\"\207"
            ["Glspl" latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("Gls" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\301=\203 \302\303\300#\207\302\304\"\207"
            ["Gls" latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("glspl" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\301=\203 \302\303\300#\207\302\304\"\207"
            ["glspl" latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("gls" :follow or-follow-glossary :face org-ref-glossary-face :help-echo or-glossary-tooltip :export
      #[771 "\211\301=\203 \302\303\300#\207\302\304\"\207"
            ["gls" latex format "\\%s{%s}" "%s"]
            7 "

(fn PATH _ FORMAT)"])
     ("bibtex" :follow org-bibtex-open :store org-bibtex-store-link)
     ("file+sys")
     ("file+emacs")
     ("doi" :follow doi-link-menu :export
      #[(doi desc format)
        "\304=\203 \300\305	
\206 \306
P$\207\307=\205% \300\310	
\206$ \306
P$\207"
        [format doi-utils-dx-doi-org-url doi desc html "<a href=\"%s%s\">%s</a>" "doi:" latex "\\href{%s%s}{%s}"]
        6])
     ("elisp" :follow org--open-elisp-link)
     ("file" :complete org-file-complete-link)
     ("ftp" :follow
      (lambda
        (path)
        (browse-url
         (concat "ftp:" path))))
     ("help" :follow org--open-help-link)
     ("http" :follow
      (lambda
        (path)
        (browse-url
         (concat "http:" path))))
     ("https" :follow
      (lambda
        (path)
        (browse-url
         (concat "https:" path))))
     ("mailto" :follow
      (lambda
        (path)
        (browse-url
         (concat "mailto:" path))))
     ("news" :follow
      (lambda
        (path)
        (browse-url
         (concat "news:" path))))
     ("shell" :follow org--open-shell-link))))
 '(package-selected-packages
   (quote
    (pandoc-mode evil-leader evil undo-tree autofill-mode auto-fill-mode nlinum sublimity add-node-modules-path ebib writegood-mode emmet-mode telephone-line apropospriate-theme prettier-js flycheck-rust flycheck-inline rust-mode tex-site auctex org-ref slime xresources-theme markdown-mode rainbow-delimiters json-mode graphql-mode elixir-mode editorconfig easy-kill f tide company yaml-mode diff-hl web-mode olivetti nim-mode cider clojure-mode smartparens paredit projectile counsel magit use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
