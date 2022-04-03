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
;  use-package-always-ensure t ;; todo this needs testing
 inhibit-startup-screen t
 global-auto-revert-non-file-buffers t)

(setq-default indent-tabs-mode nil
              tab-width 4
	          display-line-numbers t)

(global-auto-revert-mode 1) ;; revert(reload) buffers when the underlying file has changed

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(column-number-mode)
(tool-bar-mode -1)
(set-fringe-mode 10)

;; location of variables used by Custom
(load custom-file)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; location of personal elisp lib dir, for downloaded lisp files
(add-to-list 'load-path "~/src/emacsConfigs/lisp")

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
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ("C-x C-b" . counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
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

(use-package neotree
  :bind ([f8] . neotree-toggle))

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

(use-package auto-complete
  :diminish auto-complete-mode
  :config
  (ac-config-default))

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

;; If linux or mac, prepare exec-path package
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(use-package sqlplus ;; test this
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

