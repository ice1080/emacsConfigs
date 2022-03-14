(package-initialize)

;; to reload this file, use M-x load-file RET RET

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(setq user-init-file "~/src/emacsConfigs/.emacs.d/init.el")
(setq user-emacs-directory "~/src/emacsConfigs/.emacs.d/")
(setq package-user-dir "~/src/emacsConfigs/.emacs.d/elpa/")
(package-initialize)

;; location of personal elisp lib dir
(add-to-list 'load-path "~/src/emacsConfigs/lisp")

;; load the local packages
(require 'sqlplus)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(org-archive-default-command (quote org-archive-subtree))
 '(package-selected-packages
   (quote
    (prettier web-mode flycheck ivy-rich counsel which-key exec-path-from-shell rust-mode org-bullets neotree projectile auto-complete rjsx-mode langtool magit-popup kubernetes restclient groovy-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)

;; various emacs configs
(setq-default indent-tabs-mode nil
              tab-width 4
			  display-line-numbers t)
(column-number-mode)
(setq confirm-kill-emacs 'y-or-n-p)
(setq visible-bell 1)
(tool-bar-mode -1)
(set-fringe-mode 10)
(setq inhibit-startup-screen t)

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
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-log-done 'time)

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
;; TODO diminish the mode from mode line

;; TODO stop using term and try out vterm instead

;; startup commands:
(find-file "~/src/emacsConfigs/.emacs.d/init.el")

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
(split-window-right)

;; revert(reload) buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; revert dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; (global-display-line-numbers-mode)

;; (set-keyboard-coding-system nil)

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
