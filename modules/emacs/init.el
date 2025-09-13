;; Enable org-mode
(require 'org)

;; Load the main config from config.org
(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))
