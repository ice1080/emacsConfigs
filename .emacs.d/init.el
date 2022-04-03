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
 inhibit-startup-screen t)

(setq-default indent-tabs-mode nil
              tab-width 4
	          display-line-numbers t)

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

;; load the local packages
(require 'sqlplus)
;; (use-package sqlplus ;; test this
;;   :ensure nil)

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

;; org mode
(use-package org
  :hook
  (org-mode . org-bullets-mode)
  :custom
  (org-log-done 'time)
  (org-ellipsis " ▾"))

;; projectile settings
(require 'subr-x) ;; necessary because of this issue: https://github.com/bbatsov/projectile/issues/1382
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
(setq projectile-project-search-path '("~/src"))
(add-to-list 'projectile-globally-ignored-directories "node_modules")
(projectile-discover-projects-in-search-path)
(setq projectile-completion-system 'ivy)

;; neotree configs
(global-set-key [f8] 'neotree-toggle)

;; js settings, ie enable jsx mode for all js files
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
(setq js-indent-level 4)

;; prettier mode based on minor modes
(add-hook 'after-init-hook #'global-prettier-mode)

;; flycheck configs: http://codewinds.com/blog/2015-04-02-emacs-flycheck-eslint-jsx.html
(use-package flycheck
  :init (global-flycheck-mode))
;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; auto complete
(ac-config-default)
;; TODO diminish the mode from mode line, or change to a different auto complete via lsp

;; startup commands:
(find-file (concat user-emacs-directory "init.el"))

(if (string-equal system-name "ICDT-MBPIH.local")
    (find-file "~/OneDrive - ICD Tech/Notes/DatabaseScripts.org")
  )
(if (string-equal system-name "ICDT-MBPIH.local")
    (find-file "~/OneDrive - ICD Tech/Notes/GeneralNotes.org")
  )
(if (string-equal system-name "ICDT-WKIH")
    (find-file "~/OneDrive/Notes/DatabaseScripts.org")
  )
(if (string-equal system-name "ICDT-WKIH")
    (find-file "~/OneDrive/Notes/GeneralNotes.org")
  )

;; revert(reload) buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; revert dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; If linux or mac, prepare exec-path package
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(if (eq system-type 'darwin)
    ;; Oracle:
    (progn
      (exec-path-from-shell-copy-env "DYLD_LIBRARY_PATH")
      (exec-path-from-shell-copy-env "TNS_ADMIN")
      )
  )

(if (string-equal system-name "ICDT-WKIH")
    ;; Oracle:
    (progn
      (exec-path-from-shell-copy-env "LD_LIBRARY_PATH")
      (exec-path-from-shell-copy-env "TNS_ADMIN")
      )
  )

;; sqlplus stuff
(defun sqlplus-x-connect (db user pwd)
  "Build a connection string and make a connection. The point must be in an org-mode table.
Columns of the table must correspond to the `sqlplus-x-columns’ variable."
  (interactive)

  (sqlplus
   (format
    "%s/%s@%s"
    user pwd db) (concat db ".sqp"))
  )
