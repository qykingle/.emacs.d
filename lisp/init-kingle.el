(set-face-attribute 'default nil :height 220)

;;tern
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))

;; or if you want to set it globaly
(setq-default line-spacing 0.3)

(setq ring-bell-function 'ignore)

(setq helm-github-stars-username "qykingle")

(setq helm-github-stars-refetch-time 0.5)
;;youdaoyun
(setq url-automatic-caching t)

(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)

(global-hl-line-mode 1)

(set-language-environment "UTF-8")

(setq dired-dwin-target 1)

(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (let ((sym (thing-at-point 'symbol)))
            (when (stringp sym)
              (regexp-quote sym))))
        regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-s o") 'occur-dwim)

(add-hook 'occur-mode-hook
          (lambda ()
            (evil-add-hjkl-bindings occur-mode-map 'emacs
              (kbd "/")       'evil-search-forward
              (kbd "n")       'evil-search-next
              (kbd "N")       'evil-search-previous
              (kbd "C-d")     'evil-scroll-down
              (kbd "C-u")     'evil-scroll-up
              )))

(with-eval-after-load 'golden-ratio
  (add-to-list 'golden-ratio-exclude-modes "ranger-mode"))
(require 'golden-ratio)
(golden-ratio-mode 1)

(defadvice select-window-by-number
              (after golden-ratio-resize-window activate)
            (golden-ratio) nil)


(when (or (display-graphic-p)
          (string-match-p "256color"(getenv "TERM")))
  (load-theme 'spacemacs-dark t))
;;Normal Emacs Insert Motion Visual Operator
(setq evil-normal-state-tag   (propertize "[N]" 'face '((:background "#ABD78A" :foreground "black")))
      evil-emacs-state-tag    (propertize "[E]" 'face '((:background "orange" :foreground "black")))
      evil-insert-state-tag   (propertize "[I]" 'face '((:background "#82AFD6") :foreground "black"))
      evil-motion-state-tag   (propertize "[M]" 'face '((:background "blue") :foreground "white"))
      evil-visual-state-tag   (propertize "[V]" 'face '((:background "#DAAFD6" :foreground "black")))
      evil-operator-state-tag (propertize "[O]" 'face '((:background "purple"))))

;; 简化 major-mode 的名字，替换表中没有的显示原名
(defun codefalling//simplify-major-mode-name ()
  "Return simplifyed major mode name"
  (let* ((major-name (format-mode-line "%m"))
         (replace-table '(Emacs-Lisp "𝝀"
                                     Spacemacs\ buffer "𝓢"
                                     Python "𝝅"
                                     Shell ">"
                                     Makrdown "𝓜"
                                     GFM "𝓜"
                                     Org "𝒪"
                                     Text "𝓣"
                                     Fundamental "ℱ"
                                     ))
         (replace-name (plist-get replace-table (intern major-name))))
    (if replace-name replace-name major-name
        )))

(setq-default
 mode-line-format
 (list
  ;; the buffer name; the file name as a tool tip
  " "
  '(:eval (propertize "%b " 'face 'font-lock-keyword-face
                      'help-echo (buffer-file-name)))

  ;; line and column
  "(" ;; '%02' to set to 2 chars at least; prevents flickering
  (propertize "%02l" 'face 'font-lock-type-face) ","
  (propertize "%02c" 'face 'font-lock-type-face)
  ") "

  ;; relative position, size of file
  "["
  (propertize "%p" 'face 'font-lock-constant-face) ;; % above top
  "/"
  (propertize "%I" 'face 'font-lock-constant-face) ;; size
  "] "

  ;; the current major mode for the buffer.
  "["

  '(:eval (propertize (codefalling//simplify-major-mode-name) 'face 'font-lock-string-face
                      'help-echo buffer-file-coding-system))
  "] "


  "[" ;; insert vs overwrite mode, input-method in a tooltip
  '(:eval (propertize (if overwrite-mode "Ovr" "Ins")
                      'face 'font-lock-preprocessor-face
                      'help-echo (concat "Buffer is in "
                                         (if overwrite-mode "overwrite" "insert") " mode")))

  ;; was this buffer modified since the last save?
  '(:eval (when (buffer-modified-p)
            (concat ","  (propertize "Mod"
                                     'face 'font-lock-warning-face
                                     'help-echo "Buffer has been modified"))))

  ;; is this buffer read-only?
  '(:eval (when buffer-read-only
            (concat ","  (propertize "RO"
                                     'face 'font-lock-type-face
                                     'help-echo "Buffer is read-only"))))
  "] "

  ;; evil state
  '(:eval (evil-generate-mode-line-tag evil-state))

  " "
  ;; add the time, with the date and the emacs uptime in the tooltip
  '(:eval (propertize (format-time-string "%H:%M")
                      'help-echo
                      (concat (format-time-string "%c; ")
                              (emacs-uptime "Uptime:%hh"))))
  " --"
  ;; i don't want to see minor-modes; but if you want, uncomment this:
  ;; minor-mode-alist  ;; list of minor modes
  "%-" ;; fill with '-'
  ))

(provide 'init-kingle)
