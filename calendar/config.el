;;; private/calendar/config.el -*- lexical-binding: t; -*-
(defvar org-gcal-secret-file "~/.emacs.d/modules/private/org/secret.el")
(defvar +calendar-open-calendar-function '+calendar/open-calendar)
(def-package! calfw
  :commands (cfw:open-calendar-buffer)
  :config

  ;; better frame for calendar
  (setq
   cfw:render-line-breaker 'cfw:render-line-breaker-none
   cfw:face-item-separator-color nil
   cfw:fchar-junction ?╋
   cfw:fchar-vertical-line ?┃
   cfw:fchar-horizontal-line ?━
   cfw:fchar-left-junction ?┣
   cfw:fchar-right-junction ?┫
   cfw:fchar-top-junction ?┯
   cfw:fchar-top-left-corner ?┏
   cfw:fchar-top-right-corner ?┓)


  (defun cfw:render-button (title command &optional state)
    "render-button
 TITLE
 COMMAND
 STATE"
    (let ((text (concat " " title " "))
          (keymap (make-sparse-keymap)))
      (cfw:rt text (if state 'cfw:face-toolbar-button-on
                     'cfw:face-toolbar-button-off))
      (define-key keymap [mouse-1] command)
      (cfw:tp text 'keymap keymap)
      (cfw:tp text 'mouse-face 'highlight)
      text))
  (map! :map cfw:calendar-mode-map
        "q" #'+calendar/quit)
  (add-hook! 'cfw:calendar-mode-hook (solaire-mode +1)
    (doom-hide-modeline-mode)))

(def-package! calfw-org
  :commands (cfw:open-org-calendar
             cfw:org-create-source
             cfw:open-org-calendar-withkevin
             my-open-calendar))

(def-package! org-gcal
  :commands (org-gcal-sync
             org-gcal-fetch
             org-gcal-post-at-point
             org-gcal-delete-at-point)
  :init
  (setq-default org-gcal-dir (concat doom-etc-dir "org-gcal/"))
  :config
  (load-file org-gcal-secret-file)
  ;; hack to avoid the deferred.el error
  (defun org-gcal--notify (title mes)
    (message "org-gcal::%s - %s" title mes)))
