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
;; ;; disable jshint since we prefer eslint checking
;; (setq-default flycheck-disabled-checkers
;;               (append flycheck-disabled-checkers
;;                       '(javascript-jshint)))
;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; ;; customize flycheck temp file prefix
;; (setq-default flycheck-temp-prefix ".flycheck")
;; ;; disable json-jsonlist checking for json files
;; (setq-default flycheck-disabled-checkers
;;   (append flycheck-disabled-checkers
;;     '(json-jsonlist)))
;; ;; use local eslint from node_modules before global
;; ;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
;; (defun my/use-eslint-from-node-modules ()
;;   (let* ((root (locate-dominating-file
;;                 (or (buffer-file-name) default-directory)
;;                 "node_modules"))
;;          (eslint (and root
;;                       (expand-file-name "node_modules/eslint/bin/eslint.js"
;;                                         root))))
;;     (when (and eslint (file-executable-p eslint))
;;       (setq-local flycheck-javascript-eslint-executable eslint))))
;; (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;; turn on auto-complete mode all the time
;; todo eventually remove this or replace with ivy in places
(define-globalized-minor-mode my-global-ac-mode auto-complete-mode
  (lambda () (auto-complete-mode 1)))
(my-global-ac-mode 1)

;; shell command prompt customizations
(setq comint-prompt-read-only t)
;; TODO for clearing the buffer: https://stackoverflow.com/questions/7733668/command-to-clear-shell-while-using-emacs-shell
;; would have to use their function, and then also add in setting the comint prompt to not read only, then clear, then set to read only...
;; this is for different shell, but could possibly use the function https://emacs.stackexchange.com/questions/12503/how-to-clear-the-eshell#:~:text=There%20is%20a%20function%20in,the%20emacs%2Ddevel%20mailing%20list.&text=Typing%20clear%20in%20eshell%20will%20then%20result%20in%20clearing%20the%20buffer.

;; TODO need to also turn off autocomplete in shell, so that it doesn't get in the way of the tab-completion in the shell

;; TODO need to figure out coloring in the shell

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
