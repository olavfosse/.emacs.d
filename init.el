(use-package use-package
  :ensure nil
  :demand t
  :config
  ;; Trade startup time for the simplicity of having everything loaded
  ;; all the time.
  (setq use-package-always-ensure t
	use-package-always-demand t))

(use-package package
  :ensure nil
  :config
  (add-to-list
   'package-archives
   '("melpa" . "https://melpa.org/packages/"))
  (package-initialize))

(use-package modalka
  :ensure t
  :config
  ;; I'm not so sure about modalka so just use it here and there for
  ;; now, it's the neatest modal editing lib doe.
  ;; (add-hook 'text-mode-hook #'modalka-mode)
  ;; (add-hook 'prog-mode-hook #'modalka-mode)
  
  ;; (setq-default cursor-type '(bar . 1))
  ;; (setq modalka-cursor-type 'box)

  (define-key modalka-mode-map "x" ctl-x-map)
  (define-key ctl-x-map (kbd "e") #'eval-last-sexp)
  (define-key ctl-x-map (kbd "s") #'save-buffer)

  (add-to-list 'modalka-excluded-modes 'magit-status-mode)
  (global-set-key (kbd "<f1>") #'modalka-mode)
  )

(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(global-set-key (kbd "s-n") 'make-frame)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(tool-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Don't litter!!!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Don't create garbage files in my working directories:
(mkdir "~/.emacs.d/auto-save" t)
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save/" t)))

;; > For the common case of all backups going into one directory, the
;; > alist should contain a single element pairing "." with the
;; > appropriate directory name.
(mkdir "~/.emacs.d/backup" t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))

(scroll-bar-mode -1)

(use-package vertico
  :config
  (vertico-mode)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; It's really aids to search without this setting
  (setq vertico-cycle t)
  )


(use-package corfu
  ;; Optional customizations
  :custom
  ;; Prevent quitting corfu when inserting " " (space). This is
  ;; desireable since we are using orderless completion and orderless
  ;; completion uses space to separate the regexes.
  (corfu-quit-at-boundary nil)

  ;;

  ;; Enable auto completion
  (corfu-auto t)           

  ;; Don't quit on no match (so i can backspace and keep going)
  ;; (corfu-quit-no-match nil)

  ;; Aggressive completion
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 0)
  :init
  (global-corfu-mode))


;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :config
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


;; Optionally use the `orderless' completion style.
(use-package orderless
  :config
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


;; Set huge font size
(if t (set-face-attribute 'default nil :height 200))


(column-number-mode 1)





(use-package markdown-mode)








(use-package paredit
  :config
  ;; Too invasive, for examples overwrites `M-s o` (occur)
  ;; (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  ;; (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  )

(use-package babashka
    :config
    (global-set-key  (kbd "C-c t") 'babashka-tasks))

(use-package cider
  :after (org)
  :config


  ;; https://github.com/nextjournal/clerk#emacs
  (defun clerk-show ()
    (interactive)
    (when-let
	((filename
          (buffer-file-name)))
      (save-buffer)
      (cider-interactive-eval
       (concat "(nextjournal.clerk/show! \"" filename "\")"))))

  (setq cider-repl-display-help-banner nil)
  


  
  (define-key cider-mode-map (kbd "C-c C-n") 'clerk-show)
  (define-key markdown-mode-map (kbd "C-c C-n") 'clerk-show)
  (define-key org-mode-map (kbd "C-c C-n") 'clerk-show)



  

  ;; (add-hook 'clojure-mode-hook 'eglot-ensure) ;; I just found this annoying... I haven't given it a proper shot yet. some other time...

  ;; By default this is regex isearch 
  (global-set-key  (kbd "C-M-s") 'paredit-forward-slurp-sexp)


  )








(use-package eshell
  :ensure nil
  :init
  (setq eshell-banner-message ""))
(use-package elisp-mode
  :ensure nil ;; Remember to use `:ensure nil` on built-in packages
  :bind
  (:map emacs-lisp-mode-map
	;; Like in `cider-mode':
	;; TODO: make a pr to add this shortcut upstream
	("C-c C-k" . eval-buffer)))














(use-package magit
  :custom
  (git-commit-summary-max-length 200 "It's not the 1800s anymore, nobody is programming on 80-column wide punchcards/terminals. Use as little as you need and no less.")
  (magit-clone-default-directory "~/Developer/")
  (magit-clone-set-remote.pushDefault t "set it without prompting")
  (magit-save-repository-buffers nil "don't prompt to save files when running magit commands")
  (magit-list-refs-sortby "-creatordate" "sort refs by committer or tagger dates"))


(transient-define-argument magit-tag:--message ()
  :description "Use message"
  :class 'transient-option
  :shortarg "-m"
  :argument "--message="
  ;; Empty (annotated)tag messages must be permitted because it is
  ;; impossible to create them interactively.
  :allow-empty t)


(transient-append-suffix
  'magit-tag
  "-u"
  '(magit-tag:--message))


(use-package git-modes)
























;; TODO: set up https://difftastic.wilfred.me.uk




;; TODO: deadgrep maximalism, read through
;; https://github.com/Wilfred/deadgrep#keybindings and other
;; documentation if they have any
;;
;; The guy also authored ag.el and he has a overview of the
;; alternatives so i think this is the best ripgrep
;; ui. https://github.com/Wilfred/deadgrep/blob/master/docs/ALTERNATIVES.md
(use-package deadgrep
  :bind
  ;; Same as vscode :shrug:
  ("C-c f" . deadgrep))










;; Registers to make visiting files quickly
(progn
  (set-register ?i '(file . "~/.emacs.d/init.el")) ;; C-x r j i
  (set-register ?k '(file . "~/Knowledge/")) ;; C-x r j k
  )





(use-package js
  :ensure nil
  :config
  (setq olav-js-golf-repl-display-exception   "(r=i=>i===null||r(prompt((v=>{try{v=eval(i)}catch(e){v=e};return v})())))()")
  (setq olav-js-golf-repl-propagate-exception "(r=i=>i===null||r(prompt(eval(i))))()")
  ;; this one is useful when using a buggy javascript toolchain which cant handle the one above:
  ;; (setq olav-js-long-repl-display-exception   "(r=i=>i===null||r(prompt((v=>{try{v=eval(i)}catch(e){v=e};return v})())))()")
  (defun olav-insert-js-golf-repl-display-exception ()
    (interactive)
    (insert olav-js-golf-repl-display-exception))
  :bind
  (:map js-mode-map
	;; TODO: improve binding
	("C-M-R" . olav-insert-js-golf-repl-display-exception)))





(use-package move-text
  :config
  ;; Alt-{up,down} like in vscode
  (move-text-default-bindings))









(defun olav-three-vertical-windows-fullscreen ()
  (interactive)
  (toggle-frame-maximized) ;; (toggle-frame-fullscreen)
  
  (delete-other-windows)
  (split-window-right)
  (split-window-right)
  (balance-windows))


(global-set-key (kbd "C-c w") 'olav-three-vertical-windows-fullscreen)

(defun olav-balanced-split-window-below () (interactive) (split-window-below) (balance-windows))
(global-set-key (kbd "C-x 2") 'olav-balanced-split-window-below)
(global-set-key (kbd "s-M-t") 'olav-balanced-split-window-below)
(global-set-key (kbd "s-2") 'olav-balanced-split-window-below)

(defun olav-balanced-split-window-right () (interactive) (split-window-right) (balance-windows))
(global-set-key (kbd "C-x 3") 'olav-balanced-split-window-right)
(global-set-key (kbd "s-t") 'olav-balanced-split-window-right)
(global-set-key (kbd "s-3") 'olav-balanced-split-window-right)



(defun olav-balanced-delete-window () (interactive) (delete-window) (balance-windows))
(global-set-key (kbd "C-x 0") 'olav-balanced-delete-window)
(global-set-key (kbd "s-w") 'olav-balanced-delete-window)
(defun olav-balanced-kill-buffer-and-window () (interactive) (kill-buffer-and-window) (balance-windows))
(global-set-key (kbd "s-M-w") 'olav-balanced-kill-buffer-and-window)








(defun xah-open-in-textedit ()
  "Open the current file or `dired' marked files in Mac's TextEdit.
This command is for macOS only.

URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2017-11-21"
  (interactive)
  (let* (
         ($file-list
          (if (string-equal major-mode "dired-mode")
	      (dired-get-marked-files)
            (list (buffer-file-name))))
         ($do-it-p (if (<= (length $file-list) 5)
		       t
                     (y-or-n-p "Open more than 5 files? "))))
    (when $do-it-p
      (cond
       ((string-equal system-type "darwin")
        (mapc
         (lambda ($fpath)
           (shell-command
            (format "open -a TextEdit.app \"%s\"" $fpath))) $file-list))))))

(global-set-key (kbd "C-c s") 'xah-open-in-textedit) ;; s for spell check






;; Default is -al, i add -h for human readable sizes
(setq dired-listing-switches "-alh")







(use-package git-timemachine)
(put 'narrow-to-region 'disabled nil)

(use-package compile
  :ensure nil
  :bind (("C-c c" . recompile)
	 ("C-c M-c" . compile)))








;; TODO: interactively take a seconds argument
(defun olav-flash ()
  "Load a light theme for a few seconds, then disable it."
  (interactive)
  (load-theme 'modus-operandi t)
  (sleep-for 6)
  (disable-theme 'modus-operandi))

(global-set-key (kbd "C-c l") 'olav-flash)








;; (setq debug-on-error t)
(server-start)





















;; (use-package org-download)

;; ;; Drag-and-drop to `dired`
;; (add-hook 'dired-mode-hook 'org-download-enable)










(use-package sparql-mode)

(use-package org
  :config
  ;; My muscle memory is that M-<right/left> is bound to
  ;; right/left-word. Org binds that to
  ;; org-metaright/left. org-metaright/left is still useful so I just
  ;; replace the right/left-word keys with the org-metaright/left
  ;; keys. Works great :-)!
  (define-key org-mode-map (kbd "M-<right>") 'right-word)
  (define-key org-mode-map (kbd "M-<left>") 'left-word)
  (define-key org-mode-map (kbd "M-f") 'org-metaright)
  (define-key org-mode-map (kbd "M-b") 'org-metaleft)


  ;; https://orgmode.org/worg/org-contrib/babel/languages/index.html
  
  ;; Make shell source blocks evaluatable:
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((shell . t)
				 (dot . t)
				 (sparql . t)
				 (python . t)
				 (C . t)
				 ))

  (setq org-babel-python-command "python3")

  )





















(progn 
  (defun olav-uuid ()
    (-> (shell-command-to-string "uuidgen")
	string-trim))

  (defun olav-print-uuid ()
    "Useful for debugging"
    (interactive)
    (let ((uuid (olav-uuid)))
      (insert (cond ((derived-mode-p 'cmake-mode) (concat "MESSAGE(" uuid ")"))
		    ((derived-mode-p 'emacs-lisp-mode) (concat "(message \"" uuid "\")"))
		    ((derived-mode-p 'python-mode) (concat "print(\"" uuid "\")"))
		    ((derived-mode-p 'js-mode) (concat "console.log(\"" uuid "\")"))
		    ((derived-mode-p 'js2-mode) (concat "console.log(\"" uuid "\")"))
		    ((derived-mode-p 'rust-mode) (concat "println!(\"" uuid "\");"))
		    ((derived-mode-p 'clojure-mode) (concat "(println \"" uuid "\")"))
		    (uuid)
		    )))))













(add-hook 'before-save-hook 'olav-org-mode-delete-trailing-whitespace)

(defun olav-org-mode-delete-trailing-whitespace ()
  (when (derived-mode-p 'org-mode)
    (delete-trailing-whitespace)))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (setq org-roam-directory "~/Knowledge"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
	 ("C-c n 4 f" . olav-org-roam-node-find-other-window)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
	 ("C-c n n" . org-id-get-create) ;; turn current section into a org-roam node
	 ("C-c n e" . org-roam-tag-add) ;; emne~=tag
	 ("C-c n a" . org-roam-alias-add)
	 ("C-c n r" . org-roam-ref-add) ;; this should be used for URLs
	  
	 
	 
         ;; Dailies
	 ("C-c n t" . org-roam-dailies-goto-today)
	 ("C-c n <left>" . org-roam-dailies-goto-previous-note)
	 ("C-c n <right>" . org-roam-dailies-goto-next-note)
	 ("C-c n M-t" . org-roam-dailies-goto-yesterday)
         ("C-c n j" . org-roam-dailies-capture-today)
	 )
  :config
  (setq org-agenda-files '("~/Knowledge/daily"
			   "~/Knowledge/projects"
			   "~/Knowledge"))
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:60} ${tags}"))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)

  (cl-defun olav-org-roam-node-find-other-window (&optional other-node initial-input filter-fn pred &key templates)
    "HACK: this is just `org-roam-node-find-file' copy-pasted and
           modified, probably not the right way to do this.

Find and open an Org-roam node by its title or alias.
INITIAL-INPUT is the initial input for the prompt.  FILTER-FN is
a function to filter out nodes: it takes an `org-roam-node', and
when nil is returned the node will be filtered out.  If
OTHER-WINDOW, visit the NODE in another window.  The TEMPLATES,
if provided, override the list of capture templates (see
`org-roam-capture-'.)"
  (interactive current-prefix-arg)
  (let ((node (org-roam-node-read initial-input filter-fn pred)))
    (if (org-roam-node-file node)
        (org-roam-node-visit node t)
      (org-roam-capture-
       :node node
       :templates templates
       :props '(:finalize find-file)))))

  (use-package org-roam-ui)
  )



;; TODO: set bbdb up, gnus recommends it in the manual. returns an
;;       error so imma learn edebug and step through it
(when nil
  (require 'bbdb)
  (setq bbdb-north-american-phone-numbers-p nil)
  (setq bbdb-user-mail-names
	(regexp-opt '("Your.Email@here.invalid"
                      "Your.other@mail.there.invalid")))
  (setq bbdb-complete-name-allow-cycling t)
  (setq bbdb-use-pop-up nil))




(progn
  (require 'erc)
  ;; I use IRC for ephemeral communications only and therefore do not
  ;; utilize notifications or a bouncer. I refer people to my email in
  ;; case they need to contact me when I am not present.
  (defun erc-quit/part-reason-default ()
    "email me at {mail,post,spam}@olavfosse.no")
  ;; PRevent accidentally sending messages
  (define-key erc-mode-map (kbd "RET") nil)
  ;; Perhaps C-c C-c would be mroe apropriate
  (define-key erc-mode-map (kbd "C-c <C-return>") 'erc-send-current-line) 
  )

(defun olav-window-other-or-split-below ()
  (interactive)
  (if (> (count-windows 0) 1)
      (other-window 1)
    ;; switch-to-buffer-other-window is NOT equivalent to the following two function calls, because they will always split horizontally which is not the case for switch-to-buffer-other-window.
    (split-window-below)))
(defun olav-window-other-or-split-below-other-direction ()
  "If there is more than one window in the current frame, switch
to other window, otherwise split window below."
  (interactive)
  (if (> (count-windows 0) 1)
      (other-window -1)
    (split-window-below)))

(defun olav-window-other-or-split-right ()
  (interactive)
  (if (> (count-windows 0) 1)
      (other-window 1)
    ;; switch-to-buffer-other-window is NOT equivalent to the following two function calls, because they will always split horizontally which is not the case for switch-to-buffer-other-window.
    (split-window-right)))
(defun olav-window-other-or-split-right-other-direction ()
  "If there is more than one window in the current frame, switch
to other window, otherwise split window below."
  (interactive)
  (if (> (count-windows 0) 1)
      (other-window -1)
    (split-window-right)))


(global-set-key (kbd "C-`") 'olav-window-other-or-split-right)
(global-set-key (kbd "C-~") 'olav-window-other-or-split-right-other-direction) ;; ` + shift




(setq save-silently nil) 


(defun olav-frame-other-or-make ()
  "If there is more than one frame, switch to other frame,
otherwise make a new frame."
  (interactive)
  (if (> (length (frame-list)) 1)
      (other-frame 1)
    (make-frame)))
(global-set-key (kbd "s-`") 'olav-frame-other-or-make)






(setq dired-recursive-copies 'always) ;; Copy directories recursively without prompting

(defun olav-set-font ()
  "Select font."
  (interactive)
  (set-frame-font (completing-read "Font: " (x-list-fonts "*"))))

;; info
(setq Info-hide-note-references nil) 	;show the markup, maybe i will subconciously learn how to write info :p
;; (setq Info-enable-active-nodes t) 	;allow executing inline lisp code

;; TODO: set up https://git.sr.ht/~olavfosse/dosomething/tree/master/item/dosomething.el



(global-set-key (kbd "C-c l") 'org-store-link)

(use-package which-key
  :config
  (which-key-mode))






(use-package man
  :ensure nil
  ;; TODO: make a patch to emacs which adds a command
  ;;       `Man-goto-examples-section' bound to e in man mode, just like
  ;;       `Man-goto-see-also-section'
  ;;
  ;; I don't use `woman' because it is buggy (doesn't render man pages
  ;; correctly). It also caches stuff and requires you to manually
  ;; invalidate it which is AWFUL ux and just plain retarded.
  ;;
  ;; BUG: does not hande filenames containing ":" correctly (I think).
  ;;
  ;; (setq woman-manpath (split-string (shell-command-to-string "man --path") ":"))
  ;;
  ;; (global-set-key (kbd "s-m") 'woman) ;; s-M is `man'
  ;;

  :bind (("C-c m" . man)))






(defun olav-open-Terminal ()
  (interactive)
  (shell-command (concat "open -a Terminal.app \"" default-directory "\"")))





;; TODO: set up https://difftastic.wilfred.me.uk


;; Norwegian characters
(global-set-key (kbd "C-c a") (lambda () (interactive) (insert "å")))
(global-set-key (kbd "C-c A") (lambda () (interactive) (insert "Å")))
(global-set-key (kbd "C-c e") (lambda () (interactive) (insert "æ")))
(global-set-key (kbd "C-c E") (lambda () (interactive) (insert "Æ")))
(global-set-key (kbd "C-c o") (lambda () (interactive) (insert "ø")))
(global-set-key (kbd "C-c O") (lambda () (interactive) (insert "Ø")))

;; I've made the mistake of sending an email without subject 2 times
;; now, time to fix it!
(defun olav-confirm-empty-subject ()
  "Allow user to quit when current message subject is empty."
  (or (message-field-value "Subject")
      (yes-or-no-p "Really send without Subject? ")
      (keyboard-quit)))
(add-hook 'message-send-hook #'olav-confirm-empty-subject)


(setq ring-bell-function 'ignore)

;; Whether to wrap lines visuaally. currently disabled:
(global-visual-line-mode nil)

(use-package x86-lookup
  :config 
  (setq x86-lookup-pdf "~/.emacs.d/x86-lookup.pdf")
  (global-set-key (kbd "C-h 8") #'x86-lookup))

;; (add-to-list 'load-path "~/Developer/chatgpt-shell")
;; (require 'chatgpt-shell)
;; ;; or if using auth-sources, e.g., so the file ~/.authinfo has this line:
;; ;;  machine openai.com password OPENAI_KEY
;; (setq chatgpt-shell-openai-key
;;       (plist-get (car (auth-source-search :host "irc.libera.chat"))
;;                  :secret))




;; Question: How do I enable hs-minor-mode for all buffers? Only output the code.
;; ChatGPT answer:
(add-hook 'prog-mode-hook #'hs-minor-mode)


(require 'hideshow)
;; This code was created by using a ChatGPT conversation:
(define-key hs-minor-mode-map (kbd "C-c h") 'hs-toggle-hiding)
(define-key hs-minor-mode-map (kbd "C-c r") 'hs-hide-level)
(define-key hs-minor-mode-map (kbd "C-c d") 'hs-show-all)




(progn
  (defun search-knowledge (search-term)
    (interactive "sSearch term: ")
    (deadgrep search-term "~/Knowledge"))
  
  (global-set-key (kbd "C-c n d") 'search-knowledge))



(defun olav-org-roam-create-org-ai-note ()
  (interactive)
  (let ((question (read-from-minibuffer "Enter your question: ")))
    (org-roam-node-find nil question)
    (insert "#+begin_ai\n")
    (insert question)
    (insert "\n#+end_ai")
    (previous-line)
    (org-capture-finalize t)
    (org-ai-complete-block)))


(defun olav-org-append-ai-prompt-to-scratch ()
  (interactive)
  (let ((question (read-from-minibuffer "Enter your question: ")))
    (find-file "~/Knowledge/20230331161927-scratch.org")
    (end-of-buffer)
    (insert "\n")
    (insert "#+begin_ai\n")
    (insert question)
    (insert "\n#+end_ai")
    (previous-line)
    (org-ai-complete-block)))

(global-set-key (kbd "C-c n b") 'olav-org-append-ai-prompt-to-scratch)



(use-package lsp-mode)
(use-package rustic)



(setq org-startup-folded t)





(defun olav-eval-c-buffer ()
  "Compile and run the current C buffer."
  (interactive)
  (write-region (point-min) (point-max) "/tmp/olav-eval-c-buffer-file.c")
  (shell-command "cc /tmp/olav-eval-c-buffer-file.c -o /tmp/olav-eval-c-buffer-file && /tmp/olav-eval-c-buffer-file"))




(global-set-key (kbd "M-%") 'query-replace-regexp)

(defun olav-olavfosseno ()
  (interactive)
  (find-file "/ssh:olavfosseno:/root"))

(setq comint-pager "cat")





(use-package ledger-mode)

























(use-package project
  :ensure nil
  :config
  
  (setq project-switch-commands
	'((magit-project-status "Magit status" "m")
	  (project-find-file "Find file")
	  (project-find-regexp "Find regexp")
	  (project-find-dir "Find directory")
	  (project-eshell "Eshell")
	  (babashka-project-tasks "Babashka task" "t")))  

  (project-remember-projects-under "/Users/olav/Developer/" t))


(use-package eglot
  :ensure nil
  :custom
  ;; Don't prompt after i ask to perform a code action etc
  (eglot-confirm-server-initiated-edits nil)
  ;; clojure-lsp takes a long time to start up...
  (eglot-connect-timeout 120)
  :config
  ;;(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
  ;;(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
  ;;(define-key eglot-mode-map (kbd "C-c h") 'eldoc)
  (global-set-key (kbd "C-c g c") 'eglot-code-actions)
  (global-set-key (kbd "C-c g i") 'eglot-code-action-organize-imports)
  )


















(use-package consult
  :bind (("C-s" . consult-line)
	 ("C-l" . consult-git-grep)
	 ("C-r" . consult-line-multi)
	 ("M-g i" . consult-imenu)
	 ("C-x b" . consult-buffer))


  )

(use-package eww
  :ensure nil

  :config
  ;; Make eww not be sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo wide
  (setq shr-max-width 80))


(use-package go-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode)))

;; a mode which draws a line from top to bottom of current line. Handy
;; when making tables
(use-package vline)


;; (use-package chatgpt
;;   :defer t
;;   :bind ("C-c q" . chatgpt-query))
;;(setenv "OPENAI_API_KEY" (auth-source-pick-first-password :host "api.openai.com"))
;;(add-to-list 'load-path "~/Developer/chatgpt.el")
;;(require 'chatgpt)

(add-to-list 'load-path "~/Developer/copilot.el")
(require 'copilot)
;;  (add-hook 'prog-mode-hook 'copilot-mode)
(add-hook 'cider-mode-hook 'copilot-mode) ;; could go on
					  ;; clojure-mode-hook but i
					  ;; prefer turning on
					  ;; manually fr

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "s-<up>") 'copilot-previous-completion)
(define-key copilot-completion-map (kbd "s-<down>") 'copilot-next-completion)




(defun olav-comem ()
  (interactive)
  (shell-command "git commit --message '' --allow-empty-message")
  (magit-refresh))
(global-set-key (kbd "s-g") 'olav-comem)

(defun olav-comdep ()
  (interactive)
  (shell-command "git commit --message 'Deploy' --allow-empty-message --allow-empty")
  (magit-refresh))


(use-package org-ai
  :ensure t
  :commands (org-ai-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode)
  ;; (org-ai-global-mode) ; installs global keybindings on C-c M-a
  :config
  ;; If asked, gpt-4 says that it is gpt 3. It does this on the
  ;; playground too so i think it's just lying
  ;; https://platform.openai.com/playground/p/7LLHnRA3j2ajtBePZMzZNlm7?model=gpt-4
  ;;
  ;; It's so weird that it misreprots it's version but that's all really
  (setq org-ai-default-chat-model "gpt-4")
  
  ;; Putting all images here is not perfect, but it's good enough for
  ;; now and probably for ever.
  (setq org-ai-image-directory "~/Knowledge/org-ai-images/")

  (add-to-list 'org-structure-template-alist '("d" . "ai :image :size 256x256"))
  (add-to-list 'org-structure-template-alist '("g" . "ai"))

  (global-set-key (kbd "C-c M-a") org-ai-global-prefix-map)
  )

