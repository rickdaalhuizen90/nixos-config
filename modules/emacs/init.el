;;
;; --- Package Management ---
;;
;; This section sets up MELPA as a package source and enables
;; use-package for a cleaner, declarative configuration.

(require 'package)

;; Add MELPA to the list of package archives.
;; This is where most community packages are found.
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Initialize the package system.
(package-initialize)

;; Check for new packages and install them.
;; The (package-refresh-contents) line is commented out as it can be slow.
;; You can uncomment it and run it once if you don't have an up-to-date
;; list of available packages.
;; (package-refresh-contents)

;; Install `use-package` if it's not already present.
;; This is a macro that makes package configuration much cleaner.
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
;; `use-package` will automatically install packages you require.
(setq use-package-always-ensure t)


;;
;; --- Theme Configuration ---
;;
;; This section loads the 'doom-themes' package and sets
;; the 'doom-one' theme.

(use-package doom-themes
  :config
  ;; Load the 'doom-one' theme. The `t` argument means to
  ;; disable all other active themes.
  (load-theme 'doom-one t)

  ;; Some additional config to make the theme look a bit better.
  ;; You can customize these to your liking.
  (doom-themes-neotree-config) ; Configure neotree for Doom themes
  (doom-themes-visual-bell-config) ; Use a visual bell
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))


;;
;; --- Optional: Font and UI settings ---
;;
;; This is an optional but highly recommended section to
;; improve the general look and feel.

;; Set a font. You can change "Fira Code" to any font you have installed.
(set-face-attribute 'default nil :font "Fira Code-12" :weight 'normal)

;; Enable line numbers and line highlighting
(global-linum-mode t)
(global-hl-line-mode t)

;; Disable the menu bar, scroll bar, and tool bar for a cleaner look.
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
