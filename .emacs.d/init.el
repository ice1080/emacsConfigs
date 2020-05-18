(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(setq user-init-file "~/src/emacsConfigs/.emacs.d/init.el")
(setq user-emacs-directory "~/src/emacsConfigs/.emacs.d/")
(setq package-user-dir "~/src/emacsConfigs/.emacs.d/elpa/")
(package-initialize)

;; location of personal elisp lib dir
(add-to-list 'load-path "~/src/emacsConfigs/lisp")

;; todo move these back to with the other elpa packages
;; load the packages
(require 'sqlplus)
(require 'exec-path-from-shell)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(package-selected-packages
   (quote
    (org-bullets neotree projectile auto-complete rjsx-mode langtool magit-popup kubernetes restclient groovy-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)


;; org mode
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-log-done 'time)

;; projectile settings
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
(setq projectile-project-search-path '("~/src/"))
(add-to-list 'projectile-globally-ignored-directories "node_modules")

;; neotree
(global-set-key [f8] 'neotree-toggle)

;; shell path initialization
(if (or (eq system-type 'darwin) (string-equal system-name "ICDT-WKIH"))
    (exec-path-from-shell-initialize)
  )

;; open files
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

;; various emacs configs
(setq-default indent-tabs-mode nil
              tab-width 4
			  display-line-numbers t)
(setq confirm-kill-emacs 'y-or-n-p)
(setq visible-bell 1)

;; js settings, ie enable jsx mode for all js files
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-jsx-mode))
(setq js-indent-level 2)

;; turn on auto-complete mode all the time
(define-globalized-minor-mode my-global-ac-mode auto-complete-mode
  (lambda () (auto-complete-mode 1)))
(my-global-ac-mode 1)

;; (global-display-line-numbers-mode)

;; (set-keyboard-coding-system nil)

;; If linux or mac, prepare exec-path package
;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))

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
