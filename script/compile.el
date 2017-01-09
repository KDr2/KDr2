(load-file "~/.emacs.d/init.el")

(defvar app-root-path
  (file-name-directory
   (substring (file-name-directory (or load-file-name (buffer-file-name))) 0 -1))
  "The root dir of this project")

(setenv "PROJECT_ROOT" app-root-path)

(defun app-file (&optional path)
  (let ((path (or path "")))
    (concatenate 'string app-root-path path)))

(load-file (app-file "script/site-util.el"))
(load-file (app-file "script/site-theme.el"))
(load-file (app-file "script/site-org-conf.el"))
(load-file (app-file "script/gen-table.el"))
(load-file (app-file "script/page-maker.el"))
(load-file (app-file "script/code-tangler.el"))

(defun export (&optional force)
  (org-publish-project "kdr2-com" force)
  (tangle-code))

(defun force-export ()
  (export t)
  (tangle-code t))
