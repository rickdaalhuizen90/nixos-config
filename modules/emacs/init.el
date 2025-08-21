;;
;; --- Package Management ---
;;
;; This section sets up MELPA as a package source and enables
;; use-package for a cleaner, declarative configuration.

(require 'package)

;; Add MELPA to the list of package archives.
;; This is where most community packages are found.
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; Initialize the package system.
(package-initialize)

;; Install `use-package` if it's not already present.
;; This is a macro that makes package configuration much cleaner.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
;; `use-package` will automatically install packages you require.
(setq use-package-always-ensure t)

;;
;; --- Performance Optimizations ---
;;
;; Optimize Emacs for better IDE performance
(setq gc-cons-threshold 100000000) ; 100MB
(setq read-process-output-max (* 1024 1024)) ; 1MB
(setq lsp-idle-delay 0.1)

;;
;; --- Clean UI Configuration (Neovim-like) ---
;;
;; Remove all GUI elements for a clean, terminal-like appearance
(menu-bar-mode -1)          ; Remove menu bar (File, Edit, etc.)
(tool-bar-mode -1)          ; Remove tool bar (icons)
(scroll-bar-mode -1)        ; Remove scroll bars
(setq inhibit-startup-screen t) ; Skip startup screen

;;
;; --- Theme Configuration ---
;;
;; PHPStorm-like dark theme
(use-package doom-themes
  :config
  (load-theme 'doom-material-dark t)
  (doom-themes-neotree-config)
  (doom-themes-visual-bell-config)
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

;; Enhanced modeline like PHPStorm's status bar
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-project-detection 'projectile
        doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-vcs-max-length 12))

;;
;; --- Font and UI Settings ---
;;
;; PHPStorm-like UI improvements
(set-face-attribute 'default nil :font "JetBrains Mono-12" :weight 'normal)

;; Enable font-lock (syntax highlighting) globally
(global-font-lock-mode 1)

;; Better line numbers (like PHPStorm)
(use-package display-line-numbers
  :ensure nil
  :hook (prog-mode . display-line-numbers-mode)
  :config
  (setq display-line-numbers-type 'relative))

;; Highlight current line
(global-hl-line-mode t)

;; Better scrolling
(setq scroll-margin 3
      scroll-conservatively 10000
      scroll-step 1)

;;
;; --- Project Management ---
;;
;; Projectile for project management (like PHPStorm projects)
(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'ivy
        projectile-switch-project-action #'projectile-dired)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; Treemacs for project tree view (like PHPStorm's project panel)
(use-package treemacs
  :bind
  (("M-0" . treemacs-select-window)
   ("C-x t 1" . treemacs-delete-other-windows)
   ("C-x t t" . treemacs)
   ("C-x t B" . treemacs-bookmark)
   ("C-x t C-t" . treemacs-find-file)
   ("C-x t M-t" . treemacs-find-tag))
  :config
  (setq treemacs-width 30))

(use-package treemacs-projectile
  :after (treemacs projectile))

;;
;; --- Auto-completion and Search ---
;;
;; Ivy/Counsel/Swiper for fuzzy finding (like PHPStorm's search everywhere)
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        ivy-wrap t))

(use-package counsel
  :after ivy
  :config
  (counsel-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper-backward)))

;; Company for auto-completion
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-selection-wrap-around t
        company-tooltip-align-annotations t
        company-tooltip-limit 20
        company-show-quick-access t))

;;
;; --- PHP Development with Intelephense ---
;;

;; PHP Mode with proper syntax highlighting
(use-package php-mode
  :mode ("\\.php\\'" . php-mode)
  :config
  (setq php-mode-coding-style 'psr2)
  ;; Ensure syntax highlighting is enabled
  (add-hook 'php-mode-hook 'font-lock-mode))

;; LSP Mode configuration
(use-package lsp-mode
  :hook ((php-mode . lsp-deferred)  ; Use lsp-deferred for better performance
         (js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (css-mode . lsp-deferred)
         (html-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :init
  ;; Performance optimizations
  (setq lsp-keymap-prefix "C-c l"
        lsp-file-watch-threshold 2000
        lsp-enable-file-watchers t)
  :config
  ;; Configure Intelephense specifically
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("intelephense" "--stdio"))
    :major-modes '(php-mode)
    :server-id 'intelephense
    :initialization-options
    '(:licenseKey nil  ; Add your license key if you have one
      :files (:maxSize 5000000
              :associations ["*.php" "*.phtml"]
              :exclude ["**/.git/**" "**/node_modules/**" "**/vendor/**/Tests/**" "**/vendor/**/tests/**"])
      :environment (:documentRoot nil
                   :includePaths []))))

  ;; Better defaults
  (setq lsp-prefer-flymake nil
        lsp-auto-guess-root t
        lsp-keep-workspace-alive nil
        lsp-enable-snippet t
        lsp-idle-delay 0.1))

;; LSP UI for better visual feedback
(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.5
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-peek-enable t))

;; LSP Treemacs integration
(use-package lsp-treemacs
  :after (lsp-mode treemacs)
  :config
  (lsp-treemacs-sync-mode 1))

;; Composer (PHP package manager) integration
(use-package composer
  :after php-mode)

;; PHP documentation
(use-package php-eldoc
  :after php-mode
  :hook (php-mode . php-eldoc-enable))

;;
;; --- Debugging ---
;;
;; Debugger Adapter Protocol support
(use-package dap-mode
  :after lsp-mode
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (require 'dap-php))

;;
;; --- Version Control ---
;;
;; Magit for Git integration (like PHPStorm's VCS)
(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-refresh-status-buffer nil))

;; Git gutter for inline Git status
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.1))

;;
;; --- Syntax Checking ---
;;
;; Flycheck for real-time syntax checking
(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-display-errors-delay 0.3
        flycheck-check-syntax-automatically '(save mode-enabled)))

;;
;; --- Code Formatting ---
;;
;; Format-all for code formatting
(use-package format-all
  :bind ("C-c f" . format-all-buffer))

;;
;; --- Multiple Cursors ---
;;
;; Multiple cursors like PHPStorm's multi-selection
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;;
;; --- Window Management ---
;;
;; Winner mode for window configuration undo/redo
(winner-mode 1)

;; Ace window for quick window switching
(use-package ace-window
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;;
;; --- Terminal Integration ---
;;
;; Vterm for better terminal emulation
(use-package vterm
  :bind ("C-c t" . vterm))

;;
;; --- Web Development ---
;;
;; Enhanced modes for web development
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.scss\\'" . web-mode)
         ("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :config
  (setq web-mode-enable-auto-pairing t
        web-mode-enable-css-colorization t
        web-mode-enable-auto-indentation t
        web-mode-enable-current-element-highlight t))

;; JSON mode
(use-package json-mode
  :mode "\\.json\\'")

;; YAML mode
(use-package yaml-mode
  :mode "\\.ya?ml\\'")

;;
;; --- Utility Functions ---
;;

;; Helper function for line duplication
(defun duplicate-line()
  "Duplicate current line"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (forward-line 1)
  (yank))

;; Toggle clean mode function
(defun toggle-clean-mode ()
  "Toggle between clean (Neovim-like) and normal Emacs GUI"
  (interactive)
  (if menu-bar-mode
      (progn
        (menu-bar-mode -1)
        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        (message "Clean mode enabled"))
    (progn
      (menu-bar-mode 1)
      (tool-bar-mode 1)
      (scroll-bar-mode 1)
      (message "Normal GUI mode enabled"))))

;;
;; --- Key Bindings (PHPStorm-like) ---
;;
;; Common PHPStorm shortcuts
(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "C-d") 'duplicate-line)
(global-set-key (kbd "C-S-k") 'kill-whole-line)
(global-set-key (kbd "C-S-f") 'counsel-rg)
(global-set-key (kbd "C-S-r") 'query-replace)
(global-set-key (kbd "F2") 'lsp-rename)
(global-set-key (kbd "C-b") 'counsel-switch-buffer)
(global-set-key (kbd "C-S-n") 'counsel-find-file)
(global-set-key (kbd "C-c u") 'toggle-clean-mode)

;;
;; --- Final Configuration ---
;;

;; Which-key for discovering key bindings
(use-package which-key
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.3))

;; Dashboard for a nice startup screen
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-items '((recents . 10)
                         (projects . 10)
                         (bookmarks . 5))))

;; Start server for external editor integration
(server-start)

;; Auto-save and backup settings
(setq auto-save-default t
      make-backup-files t
      backup-directory-alist '(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25
      recentf-max-saved-items 25)

;; Restore gc threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 800000)))

;;
;; --- Setup Instructions ---
;;
;; Before using this configuration:
;; 1. Install Node.js and npm
;; 2. Install Intelephense: npm install -g intelephense
;; 3. Restart Emacs
;; 4. Open a PHP file to activate LSP mode
;;
;; Key shortcuts:
;; - C-c l: LSP command prefix
;; - C-c p: Projectile command prefix
;; - C-c u: Toggle clean/normal GUI mode
;; - C-/: Comment line
;; - C-d: Duplicate line
;; - F2: Rename symbol
;; - C-S-f: Search in files
;; - M-0: Focus treemacs

