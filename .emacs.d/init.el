;; to reload this file, use M-x load-file RET RET

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

;; various emacs configs
(setq
 user-emacs-directory "~/src/emacsConfigs/.emacs.d/"
 user-init-file (concat user-emacs-directory "init.el")
 package-user-dir (concat user-emacs-directory "elpa/")
 custom-file (concat user-emacs-directory "custom.el")
 confirm-kill-emacs 'y-or-n-p
 visible-bell t
 use-package-always-ensure t ;; todo this needs testing
 inhibit-startup-screen t
 global-auto-revert-non-file-buffers t)

(setq-default indent-tabs-mode nil
              tab-width 4
	          display-line-numbers t
              use-short-answers t ; Replace yes/no prompts with y/n
              )

(global-auto-revert-mode 1) ;; revert(reload) buffers when the underlying file has changed

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(column-number-mode)
(tool-bar-mode -1)
(set-fringe-mode 12)

;; location of variables used by Custom
(load custom-file)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; location of personal elisp lib dir, for downloaded lisp files
(add-to-list 'load-path "~/src/emacsConfigs/lisp")

(use-package diminish)

(use-package which-key
  :init
  (setq which-key-idle-delay 0.3)
  (which-key-mode)
  :diminish which-key-mode)

(use-package ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper-backward))
  :config
  (ivy-mode 1)
  :diminish ivy-mode)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :diminish ivy-rich-mode)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("M-y" . counsel-yank-pop)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ("C-x C-b" . counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)
         ("M-y" . ivy-next-line))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package org
  :hook
  (org-mode . org-bullets-mode)
  :custom
  (org-log-done 'time)
  (org-ellipsis " ▾"))

(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c C-p" . projectile-command-map))
  :requires subr-x
  :config
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (projectile-discover-projects-in-search-path)
  :custom
  (projectile-project-search-path '("~/src"))
  (projectile-completion-system 'ivy))

(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  :custom
  (js-indent-level 4)
  (web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))))

(use-package prettier
  :init
  (add-hook 'after-init-hook 'global-prettier-mode))

;; flycheck configs: http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  ;; use eslint with web-mode for jsx files
  (flycheck-add-mode 'javascript-eslint 'web-mode))

(use-package diff-hl
  :init (global-diff-hl-mode)
  :config
  (diff-hl-show-hunk-mouse-mode)) ;; may have to change to global

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; to add javascript lsp to a new computer, run `npm i -g typescript-language-server; npm i -g typescript`
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((web-mode . lsp-deferred)
         (groovy-mode . lsp-deferred))
  :config
  (lsp-enable-which-key-integration t)
  :custom
  (lsp-auto-guess-root t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (setq lsp-ui-doc-position 'bottom)) ;; this doesn't seem to be working right.

(use-package treemacs
  :bind ([f8] . treemacs))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package lsp-treemacs
  :after (treemacs lsp))

(use-package lsp-ivy)

(use-package company
  :diminish company-mode
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; (use-package doom-themes
;;   :config
;;   (load-theme doom-gruvbox))
;;   (load-theme doom-peacock))

;; If linux or mac, prepare exec-path package
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(use-package sqlplus
  :ensure nil
  :config
  (defun sqlplus-x-connect (db user pwd)
  "Build a connection string and make a connection. The point must be in an org-mode table.
Columns of the table must correspond to the `sqlplus-x-columns’ variable."
  (interactive)

  (sqlplus
   (format
    "%s/%s@%s"
    user pwd db) (concat db ".sqp"))
  ))

(dolist (mode '(treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; startup commands:
(find-file (concat user-emacs-directory "init.el"))

(if (string-equal (system-name) "ICDT-MBPIH.local")
    (progn
      (find-file "~/OneDrive - ICD Tech/Notes/DatabaseScripts.org")
      (find-file "~/OneDrive - ICD Tech/Notes/GeneralNotes.org")
      (exec-path-from-shell-copy-env "DYLD_LIBRARY_PATH")
      (exec-path-from-shell-copy-env "TNS_ADMIN"))
  (if (string-equal (system-name) "ICDT-WKIH")
      (progn
        (find-file "~/OneDrive/Notes/DatabaseScripts.org")
        (find-file "~/OneDrive/Notes/GeneralNotes.org")
        (exec-path-from-shell-copy-env "LD_LIBRARY_PATH")
        (exec-path-from-shell-copy-env "TNS_ADMIN"))
    )
  )

