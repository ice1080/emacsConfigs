(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; location of personal elisp lib dir
(add-to-list 'load-path "~/src/emacsConfigs/lisp")

;; load the packages
;; (require "~/src/emacsConfigs/lisp/sqlplus.el")
(require 'sqlplus)
;; (require 'exec-path-from-shell)

(if (eq system-type 'darwin)
    (exec-path-from-shell-initialize)
)

(find-file "~/Documents/Notes/DatabaseScripts.md")
(find-file "~/Documents/Notes/GeneralNotes.md")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(package-selected-packages (quote (rjsx-mode langtool magit-popup kubernetes restclient groovy-mode exec-path-from-shell)))
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)

(setq-default indent-tabs-mode nil
              tab-width 4
			  display-line-numbers t)
(setq confirm-kill-emacs 'y-or-n-p)

;; (global-display-line-numbers-mode)

;; (set-keyboard-coding-system nil)

;; If linux or mac, prepare exec-path package
;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))

(if (eq system-type 'darwin)
    ;; Oracle:
    (
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
