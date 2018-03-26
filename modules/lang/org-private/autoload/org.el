;;; lang/org-private/autoload/org.el -*- lexical-binding: t; -*-

;;;###autoload
(defun export-diary-from-cal ()
  (interactive)
  (start-process-shell-command "export diary" nil "/Users/xfu/.emacs.d-backup/private/local/calendardiary 30 > /Users/xfu/Dropbox/org/cal.diary"))

;;;###autoload
(defun +org/open-brain-here ()
    (interactive)
    (let ((org-brain-path (projectile-project-root)))
      (call-interactively 'org-brain-visualize)))

;;;###autoload
(defun reflash-indentation ()
  "Fix org-indent issues, center line."
  (interactive)
  (org-indent-mode 1)
  (recenter-top-bottom))


;;;###autoload
(defun +org/work-on-heading ()
  (interactive)
  (org-clock-in)
  (+workspace-switch (nth 4 (org-heading-components)) t)
  (delete-other-windows)
  (org-tree-to-indirect-buffer)
  (other-window 1)
  (delete-other-windows)
  (+workspace/display)
  (start-process-shell-command "Focus" nil "open -g \"focus://focus\"")
  (map! :map evil-org-mode-map
        :ni "<M-return>" #'+org/finish-work-on-heading
        :ni "M-k"        #'+org/cancel-work-on-heading))

;;;###autoload
(defun +org/finish-work-on-heading ()
  (interactive)
  (setq *org-git-notes (nth 4 (org-heading-components)))
  (org-clock-out)
  (save-buffer)
  (kill-this-buffer)
  (+workspace/delete (+workspace-current-name))
  (start-process-shell-command "Unfocus" nil "open -g \"focus://unfocus\"")
  (map! :map evil-org-mode-map
        :ni "<M-return>" #'+org/work-on-heading
        :ni "M-k" nil))

;;;###autoload
(defun +org/cancel-work-on-heading ()
  (interactive)
  (setq *org-git-notes nil)
  (org-clock-cancel)
  (save-buffer)
  (kill-this-buffer)
  (+workspace/delete (+workspace-current-name))
  (start-process-shell-command "Unfocus" nil "open -g \"focus://unfocus\"")
  (map! :map evil-org-mode-map
        :ni "<M-return>" #'+org/work-on-heading
        :ni "M-k" nil))

;;;###autoload
(defun *org/shiftcontroldown (&optional n)
  "Change timestamps synchronously down in CLOCK log lines.
Optional argument N tells to change by that many units."
  (interactive "P")
  (if (and (org-at-clock-log-p) (org-at-timestamp-p 'lax))
      (let (org-support-shift-select)
        (org-clock-timestamps-down n))
    (org-timestamp-down)))

;;;###autoload
(defun *org/shiftcontrolup (&optional n)
  "Change timestamps synchronously up in CLOCK log lines.
Optional argument N tells to change by that many units."
  (interactive "P")
  (if (and (org-at-clock-log-p) (org-at-timestamp-p 'lax))
      (let (org-support-shift-select)
        (org-clock-timestamps-up n))
    (org-timestamp-up)))
