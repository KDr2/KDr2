
(defun tangle-code (&optional force)
  (let ((files (if force                   
                   (mapcar
                    (lambda (fn) (format "tangle/%s" fn))
                    (directory-files (app-file "tangle") nil "\.org$"))
                 (ignore-errors (read-sexp-from-file (app-file ".tangle-files"))))))
    (dolist (file files)
      (org-babel-tangle-file (app-file file)))
    (ignore-errors (delete-file (app-file ".tangle-files")))))
