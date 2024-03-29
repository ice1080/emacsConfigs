;;; kubernetes-namespaces.el --- Helpers for Kubernetes namespaces.  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'kubernetes-kubectl)
(require 'kubernetes-process)
(require 'kubernetes-props)
(require 'kubernetes-state)
(require 'kubernetes-yaml)


;; Requests and state management

(kubernetes-state-define-refreshers namespaces)

;; Displaying namespaces

(defun kubernetes-namespaces--read-name (state)
  "Read a namespace name from the user.

STATE is the current application state.

Update the namespace state if it not set yet."
  (-let* (((&alist 'items namespaces)
           (or (kubernetes-state--get state 'namespaces)
               (progn
                 (message "Getting namespaces...")
                 (let ((response (kubernetes-kubectl-await-on-async kubernetes-props state (-partial #'kubernetes-kubectl-get "namespaces"))))
                   (kubernetes-state-update-namespaces response)
                   response))))
          (namespaces (append namespaces nil))
          (names (-map #'kubernetes-state-resource-name namespaces)))
    (completing-read "Namespace: " names nil t)))

;;;###autoload
(defun kubernetes-display-namespace (namespace-name state)
  "Display information for a namespace in a new window.

STATE is the current application state.

NAMESPACE-NAME is the name of the namespace to display."
  (interactive (let ((state (kubernetes-state)))
                 (list (kubernetes-namespaces--read-name state) state)))
  (if-let (namespace (kubernetes-state-lookup-namespace namespace-name state))
      (select-window
       (display-buffer
        (kubernetes-yaml-make-buffer kubernetes-display-namespace-buffer-name namespace)))
    (error "Unknown namespace: %s" namespace-name)))


(provide 'kubernetes-namespaces)

;;; kubernetes-namespaces.el ends here
