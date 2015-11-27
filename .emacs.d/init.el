;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.
(modify-frame-parameters nil '((wait-for-wm . nil)))
(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode 1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode 1))

(require 'hideshow)
(setq hs-minor-mode-hook
 (lambda()
 (local-set-key [C-down] 'hs-show-block)
 (local-set-key [C-up] 'hs-hide-block)
 )
 )
(define-key hs-minor-mode-map [(S-mouse-2)] 'hs-mouse-toggle-hiding)

(which-function-mode t)

(setq inhibit-splash-screen t)
(setq compile-command "cd /home/Marvell/work/GIT/wmsdk; make")

(add-hook 'text-mode-hook 'flyspell-mode)

(add-hook 'term-mode-hook
   (lambda ()
     ;; C-x is the prefix command, rather than C-c
     (term-set-escape-char ?\C-x)
   )
)

(global-set-key [f6] '(lambda() (interactive) (load-img)))
(defun load-img ()
        (if (shell-command "cd /home/Marvell/work/GIT/wmsdk/WMSDK/tools/mc200/OpenOCD; sudo ./ramload.sh /home/Marvell/work/GIT/wmapps/wm_demo/src/wm_demo.axf &") (serial-term "/dev/ttyUSB1" 115200) ))

(require 'grep)
(global-set-key [f4] '(lambda() (interactive) (rgrep (thing-at-point 'symbol) "*.[ch]" "/home/Marvell/work/GIT/wmsdk/WMSDK" nil)))

;;(split-window-horizontally)
;;(auto-complete-mode)
(set-background-color "black")

(defvar ac-complete-gtags)
(defvar ac-complete-yasnippet)
(defalias 'acm 'auto-complete-mode)

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))
(linux-c-mode) 
(global-set-key "\C-l" 'goto-line) ; [Ctrl]-[L] 
(global-set-key [f2] 'split-window-vertically)
(global-set-key [f1] 'remove-split) 
(setq c-default-style "linux")
(global-set-key (kbd "<f3>") 'find-file)
(global-set-key (kbd "<f9>") 'next-error)
(global-set-key (kbd "<f8>") 'previous-error)
(global-set-key (kbd "<f7>") 'compile)
(global-set-key (kbd "<f11>") 'auto-fill-mode)

(mouse-wheel-mode t) 
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))


(add-to-list 'load-path dotfiles-dir)

(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit"))

;;(setq autoload-file (concat dotfiles-dir "loaddefs.el"))
;;(setq package-user-dir (concat dotfiles-dir "elpa"))
;;(setq custom-file (concat dotfiles-dir "custom.el"))

(require 'package)
;;(package-initialize)
;;(require 'starter-kit-elpa)

;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

;;(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)
;;(require 'auto-complete-clang_new)
;; backport some functionality to Emacs 22 if needed
(require 'dominating-file)

;; Load up starter kit customizations

(require 'starter-kit-defuns)
(require 'starter-kit-bindings)
(require 'starter-kit-misc)
(require 'starter-kit-registers)
;;(require 'starter-kit-eshell)
;;(require 'starter-kit-lisp)
;;(require 'starter-kit-perl)
;;(require 'starter-kit-ruby)
(require 'starter-kit-js)
(require 'xcscope)
(require 'flymake)
(require 'autopair)
;;(require 'magit)
;;(require 'modeline-posn)
;;(add-to-list 'load-path	     "~/.emacs.d/plugins")
;; (require 'yasnippet-bundle)
;; (require 'auto-conf)
(require 'auto-complete-clang)
;;(regen-autoloads)
;;(load custom-file 'noerror)

;; You can keep system- or user-specific customizations here
(setq system-specific-config (concat dotfiles-dir system-name ".el")
      user-specific-config (concat dotfiles-dir user-login-name ".el")
      user-specific-dir (concat dotfiles-dir user-login-name))
(add-to-list 'load-path user-specific-dir)

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))
(if (file-exists-p user-specific-dir)
  (mapc #'load (directory-files user-specific-dir nil ".*el$")))

;; My Customizations

;; Set colors
;(set-background-color "black")
;(set-foreground-color "green")
;(custom-set-faces '(default ((t (:background "BLACK" :foreground "CYAN")))))

;; Toggle fullscreen
(defun toggle-fullscreen()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'toggle-fullscreen)

;; Scroll one line at a time
(setq scroll-step 1)

;; Show line and column numbers on minibuffer
(line-number-mode 1)
(column-number-mode 1)

;; Enable delete selection mode
(delete-selection-mode 1)

;; Line numbers on left side
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-set-key [C-f5] 'linum-mode)

;; Avoid backup file creation
(setq make-backup-files nil)

;; Undo
(global-set-key (kbd "C-z") 'undo)

;; Enable autopair in all buffers 
;;(autopair-global-mode)
;;(setq autopair-autowrap t)

;; Default tab width
;;(setq-default c-basic-offset 8)

;; Fontsize := 10
(set-face-attribute 'default nil :height 100)

;; Switch frames in the window
(global-set-key [C-tab] 'next-multiframe-window )

;; Inserts 'TAB' character instead of spaces
;;(setq-default indent-tabs-mode t)

;; Uncomment Region
(global-set-key (kbd "C-c C-v") 'uncomment-region)

;; Displays given message in scratch by default
(setq initial-scratch-message ";; Scratch Buffer [Emacs @ Elixir]\n\n\n")

;; Switches whitespace-mode to show trailing whitespaces
;; and lines greater than 80 characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; Kernel Coding Style
;(defun c-lineup-arglist-tabs-only (ignored)
;  "Line up argument lists by tabs, not spaces"
;  (let* ((anchor (c-langelem-pos c-syntactic-element))
;	 (column (c-langelem-2nd-pos c-syntactic-element))
;	 (offset (- (1+ column) anchor))
;	 (steps (floor offset c-basic-offset)))
;    (* (max steps 1)
;       c-basic-offset)))
;
;(add-hook 'c-mode-common-hook
;          (lambda ()
;            ;; Add kernel style
;            (c-add-style
;             "linux-tabs-only"
;             '("linux" (c-offsets-alist
;                        (arglist-cont-nonempty
;                         c-lineup-gcc-asm-reg
;                         c-lineup-arglist-tabs-only))))))
;
;(add-hook 'c-mode-hook
;          (lambda ()
;            (let ((filename (buffer-file-name)))
;              ;; Enable kernel mode for the appropriate files
;              (when (and filename
;                         (string-match (expand-file-name "/")
;                                       filename))
;                (setq indent-tabs-mode t)
;                (c-set-style "linux-tabs-only")))))

;; Display Persitent Time, Day and Date
(setq display-time-day-and-date t) (display-time)

(defalias 'tg 'tags-search)

;;(add-hook 'c-mode-common-hook
;;	  (lambda ();
;;	    (define-key c-mode-map [(ctrl tab)] 'complete-tag)))

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'ac-dictionary-directories "/home/Marvell/work/GIT/wmsdk/WMSDK/TAGS")
(require 'auto-complete-config)

(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")

;; This is a way to hook tempo into cc-mode
(defvar c-tempo-tags nil
  "Tempo tags for C mode")
(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")

;;; C-Mode Templates and C++-Mode Templates (uses C-Mode Templates also)
(require 'tempo)
;;(setq tempo-interactive t)
;;(setq shift-select-mode t)
;;(delete-selection-mode 1)
(add-hook 'c-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-p") 'tempo-complete-tag)
             (tempo-use-tag-list 'c-tempo-tags)
             ))
(add-hook 'c++-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-p") 'tempo-complete-tag)
             (tempo-use-tag-list 'c-tempo-tags)
             (tempo-use-tag-list 'c++-tempo-tags)
             ))

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 160 :width normal :foundry "bitstream" :family "Bitstream Charter"))))
 '(cperl-array-face ((t (:foreground "orangered" :bold t))))
 '(cperl-hash-face ((t (:foreground "Red" :bold t))))
 '(cperl-nonoverridable-face ((t (:foreground "orange" :bold t))))
 '(cursor ((t (:background "white"))))
 '(custom-button-face ((t (:bold t :foreground "#3fdfcf"))) t)
 '(custom-group-tag-face ((t (:underline t :foreground "blue"))) t)
 '(custom-saved-face ((t (:underline t :foreground "orange"))) t)
 '(custom-state-face ((t (:foreground "green3"))) t)
 '(custom-variable-button-face ((t (:bold t :underline t :foreground "white"))) t)
 '(dired-face-permissions ((t (:foreground "green"))))
 '(font-latex-bold-face ((((class color) (background light)) (:bold t))))
 '(font-latex-italic-face ((((class color) (background light)) (:italic t))))
 '(font-latex-math-face ((((class color) (background light)) (:foreground "green3"))))
 '(font-latex-sedate-face ((((class color) (background light)) (:foreground "gold"))))
 '(font-lock-comment-face ((t (:foreground "orange3"))))
 '(font-lock-doc-string-face ((t (:foreground "Wheat3"))))
 '(font-lock-function-name-face ((t (:foreground "white" :bold t))))
 '(font-lock-keyword-face ((t (:foreground "gold"))))
 '(font-lock-preprocessor-face ((t (:foreground "red" :bold t))))
 '(font-lock-reference-face ((t (:foreground "orangered"))))
 '(font-lock-string-face ((t (:foreground "green3"))))
 '(font-lock-type-face ((t (:foreground "#886fff" :bold t))))
 '(font-lock-variable-name-face ((t (:foreground "yellow" :bold t))))
 '(font-lock-warning-face ((t (:foreground "Violetred" :bold t))))
 '(highlight ((t (:foreground "red3" :background "white"))))
 '(isearch ((t (:foreground "red" :background "white"))))
 '(list-mode-item-selected ((t (:foreground "green"))))
 '(message-cited-text ((t (:bold t :italic nil))))
 '(mouse ((t (:background "black"))))
 '(secondary-selection ((t (:foreground "white" :background "red"))))
 '(text-cursor ((t (:foreground "black" :background "green"))))
 '(zmacs-region ((t (:background "RoyalBlue")))))


;;; Preprocessor Templates (appended to c-tempo-tags)

(tempo-define-template "c-include"
		       '("include <" r ".h>" > n
			 )
		       "include"
		       "Insert a #include <> statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifdef"
		       '("ifdef " (p "ifdef-clause: " clause) > n> p n
			 "#else /* !(" (s clause) ") */" n> p n
			 "#endif /* " (s clause)" */" n>
			 )
		       "ifdef"
		       "Insert a #ifdef #else #endif statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifndef"
		       '("ifndef " (p "ifndef-clause: " clause) > n
			 "#define " (s clause) n> p n
			 "#endif /* " (s clause)" */" n>
			 )
		       "ifndef"
		       "Insert a #ifndef #define #endif statement"
		       'c-tempo-tags)
;;; C-Mode Templates

(tempo-define-template "c-printf"
		       '("printf (\"" r "\");" > n
			 )
		       "printf"
		       "Insert a printf() statement"
		       'c-tempo-tags)

(tempo-define-template "c-scanf"
		       '("scanf(\"" r "\", );" > n
			 )
		       "scanf"
		       "Insert a scanf() statement"
		       'c-tempo-tags)

(tempo-define-template "c-perror"
		       '("perror(\"" r "\");" > n
			 )
		       "perror"
		       "Insert a perror() statement"
		       'c-tempo-tags)

(tempo-define-template "c-if"
		       '(> "if (" (p "if-clause: " clause) ")" n>
                           "{" > n>
                           > r n
                           "}" > n>
                           )
		       "if"
		       "Insert a C if statement"
		       'c-tempo-tags)

(tempo-define-template "c-else"
		       '(> "else" n>
                           "{" > n>
                           > r n
                           "}" > n>
                           )
		       "else"
		       "Insert a C else statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-else"
		       '(> "if (" (p "if-clause: " clause) ")"  n>
                           "{" > n
                           > r n
                           "}" > n
                           "else" > n
                           "{" > n>
                           > r n
                           "}" > n>
                           )
		       "ifelse"
		       "Insert a C if else statement"
		       'c-tempo-tags)

(tempo-define-template "c-while"
		       '(> "while (" (p "while-clause: " clause) ")" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
		       "while"
		       "Insert a C while statement"
		       'c-tempo-tags)

(tempo-define-template "c-for"
		       '(> "for (" (p "for-clause: " clause) ")" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
		       "for"
		       "Insert a C for statement"
		       'c-tempo-tags)

(tempo-define-template "c-for-i"
		       '(> "for (" (p "variable: " var) " = 0; " (s var)
                           " < "(p "upper bound: " ub)"; " (s var) "++)" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
		       "fori"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-main"
		       '(> "int main(int argc, char *argv[])" >  n>
                           "{" > n>
                           > r n
                           > "return 0;" n>
                           > "}" > n>
                           )
		       "main"
		       "Insert a C main statement"
		       'c-tempo-tags)

(tempo-define-template "c-switch"
		       '(> "switch (" (p "switch-condition: " clause) ")" n>
                           "{" >  n>
                           "case " (p "first value: ") ":" > n> p n
                           "break;" > n> p n
                           "default:" > n> p n
                           "break;" > n
                           "}" > n>
                           )
		       "switch"
		       "Insert a C switch statement"
		       'c-tempo-tags)

(tempo-define-template "c-case"
		       '(n "case " (p "value: ") ":" > n> p n
			   "break;" > n> p
			   )
		       "case"
		       "Insert a C case statement"
		       'c-tempo-tags)

(tempo-define-template "c++-class"
		       '("class " (p "classname: " class) p > n>
                         " {" > n
                         "public:" > n
                         "" > n
			 "protected:" > n
                         "" > n
			 "private:" > n
                         "" > n
			 "};" > n
			 )
		       "class"
		       "Insert a class skeleton"
		       'c++-tempo-tags)

(add-to-list 'load-path "elpa-to-submit/color-theme.el")
(require 'nav)
(require 'ack)

(require 'sr-speedbar)
(sr-speedbar-open)
(global-set-key (kbd "s-s") 'sr-speedbar-toggle)

(setq gnus-select-method
      '(nnimap "gmail"
	              (nnimap-address "imap.gmail.com")
		             (nnimap-server-port 993)
			            (nnimap-stream ssl)))

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.gmail.com" 587
				      "spotdar@cs.stonybrook.edu" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

;; adjust this path:
(add-to-list 'load-path "~/.emacs.d/emacs-jabber")
(add-to-list 'load-path "~/.emacs.d/emacs-jabber/compat")
;; For 0.7.1 and below:
(require 'jabber)
;; For 0.7.90 and above:
(require 'jabber-autoloads)

;;(setq jabber-username "Shantanu Potdar")
;;(;;setq jabber-password "")
;;(setq jabber-nickname "")
;;(setq jabber-connection-type (quote ssl))
;;(setq jabber-network-server "talk.google.com")
;;(setq jabber-server "gmail.com")

;;(defun jabber ()
  ;;  (interactive)
 ;;   (jabber-connect)
;;    (switch-to-buffer "*-jabber-*"))

(setq jabber-account-list
    '(("spotdar@cs.stonybrook.edu" 
       (:network-server . "talk.google.com")
       (:connection-type . ssl))))

(setq 
  special-display-regexps 
  '(("jabber-chat" 
      (width . 80)
     (scroll-bar-width . 16)
     (height . 15)
     (tool-bar-lines . 0)
     (menu-bar-lines 0)
     (font . "-GURSoutline-Courier New-normal-r-normal-normal-11-82-96-96-c-70-iso8859-1")
     (left . 80))))

(add-hook 'jabber-alert-message-hooks 'jabber-message-xmessage)

(require 'fill-column-indicator)
(setq fci-rule-color "orange")
(add-hook 'after-change-major-mode-hook 'fci-mode)

;;; init.el ends here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(fill-column 80))
