; By Sabrina Johnson

; tips:
; - when making changes to file use 'M-x eval-buffer' to see changes instead of reloading
; - to see all system colors use 'M-x list-colors-display'

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

; set theme (dracula)
(unless (package-installed-p 'dracula-theme)
  (package-refresh-contents)
  (package-install 'dracula-theme))

(load-theme 'dracula t)

; set font style a size
(set-frame-font "Jetbrains Mono 15" nil t)

; set frame height and width
(set-frame-height (selected-frame) 27)
(set-frame-width (selected-frame) 60)

; set cursor type to bar
(setq-default cursor-type 'bar)

; set cursor color
(set-cursor-color "pale violet red") 

; highlight the active line
(hl-line-mode)

;; Install and configure vertico and vertico-posframe
(dolist (pkg '(vertico vertico-posframe))
  (unless (package-installed-p pkg)
    (package-refresh-contents)
    (package-install pkg)))

;; first initialize vertico (base package)
(when (require 'vertico nil t)
  (setq completion-styles '(basic substring partial-completion flex)
        completion-ignore-case t
        read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t)
  (vertico-mode 1))

;; then initialize vertico-posframe (after vertico is set up)
(when (require 'vertico-posframe nil t)
  ;; Set a lighter background color for the posframe
  (setq vertico-posframe-parameters
        '((background-color . "#383a59")))  ;; Lighter purple/blue than Dracula's background
  
  ;; Set up a thick border with color
  (setq vertico-posframe-border-width 3)
  (setq vertico-posframe-border-color "pale violet red") ;; does not work?
  
  ;; Initialize vertico-posframe mode
  (setq vertico-posframe-fallback-mode #'vertico-buffer-mode)
  (vertico-posframe-mode 1))

;; enable which-key mode for keybinding suggestions
(unless (package-installed-p 'which-key)
  (package-refresh-contents)
  (package-install 'which-key))

(when (require 'which-key nil t)
  (which-key-mode))

; go pls configuration
(unless (package-installed-p 'lsp-mode)
  (package-refresh-contents)
  (package-install 'lsp-mode))

(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(lsp-register-custom-settings
 '(("gopls.completeUnimported" t t)
   ("gopls.staticcheck" t t)))
