;; font-lock for all buffers
(global-font-lock-mode 1)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Show column-number in the mode line
(setq column-number-mode t)

;; highlight regions (when yanking)
(transient-mark-mode 1)

;; always show the line number
(setq line-number-mode t)

;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; iswitch mode is much better
(iswitchb-mode 1)

;; give me a preview in the mini buffer
(icomplete-mode 1)

;; disable menu bar
(menu-bar-mode -1)

;; stop making tilde backup files
(setq make-backup-files nil)

;; give duplicate buffers better names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; simple highlighting for files where no mode is defined
(require 'generic-x)
