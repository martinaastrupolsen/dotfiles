;; init.el --- Emacs configuration
;; Inspired by
;; - https://github.com/nilsdeppe/MyEnvironment/blob/master/.emacs.el
;; and others

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("gnu" . "http://elpa.gnu.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    magit
    material-theme
    use-package
    py-autopep8
    rustic))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-refresh-contents)
      (package-install package)))
      myPackages)

;; Extra plugins and config files are stored here
(add-to-list 'load-path (expand-file-name "~/.emacs.d/plugins"))

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(setq-default indent-tabs-mode nil) ;; No tabs thanks
(setq-default show-trailing-whitespace t)
(add-hook 'text-mode-hook 'auto-fill-mode)
(setq-default fill-column 80)
(setq column-number-mode t)
(remove-hook 'org-mode-hook #'auto-fill-mode)
(show-paren-mode t) ;; Highlight matching parens
(setq make-backup-files nil) ;; Don't make backup files
(setq auto-save-default nil) ;; No need for auto saver
(setq-default case-fold-search t ;; Case insensitive searches by default
              search-highlight t) ;; Highlight matches when searching
(setq ring-bell-function 'ignore) ;; No bells

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; key bindings
(when (eq system-type 'darwin) ;; mac specific settings
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  )

;; MAGIT CONFIGURATION
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Additional plugins
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (not (file-directory-p "~/.emacs.d/plugins"))
    (make-directory "~/.emacs.d/plugins"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; protobuf-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (not (file-exists-p "~/.emacs.d/plugins/protobuf-mode.el"))
    (url-copy-file
     "https://raw.githubusercontent.com/google/protobuf/master/editors/protobuf-mode.el"
     "~/.emacs.d/plugins/protobuf-mode.el"))
(if (file-exists-p "~/.emacs.d/plugins/protobuf-mode.el")
    (use-package protobuf-mode
      :mode ("\\.proto")
      )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rust
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rustic)

;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum-delay t)
 '(linum-eager nil)
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(package-selected-packages
   '(lsp-mode gnu-elpa-keyring-update py-autopep8 material-theme flycheck elpy ein better-defaults)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
