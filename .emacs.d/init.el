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
    (projectile auto-complete rjsx-mode langtool magit-popup kubernetes restclient groovy-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(setq js-indent-level 2)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
(setq projectile-project-search-path '("~/src/"))

(if (eq system-type 'darwin)
    (exec-path-from-shell-initialize)
)
(if (string-equal system-name "ICDT-MBPIH.local")
    (find-file "~/Documents/Notes/DatabaseScripts.md")
)
(if (string-equal system-name "ICDT-MBPIH.local")
    (find-file "~/Documents/Notes/GeneralNotes.md")
)

(setq-default indent-tabs-mode nil
              tab-width 4
			  display-line-numbers t)
(setq confirm-kill-emacs 'y-or-n-p)
(setq visible-bell 1)

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

(defun sqlplus-x-connect (db user pwd)
 "Build a connection string and make a connection. The point must be in an org-mode table.
Columns of the table must correspond to the `sqlplus-x-columns’ variable."
 (interactive)

 (sqlplus
  (format
   "%s/%s@%s"
   user pwd db) (concat db ".sqp"))
 )
