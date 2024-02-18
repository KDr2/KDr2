;; extract code from all files named as '*.lit.org'

(defun tangle-output (file)
  (let* ((file-name (file-name-nondirectory file))
         (code-file (substring file-name 0 -8)) ;; f.c.lit.org -> f.c
         (code-path (app-file (concat "output/static/lit/" code-file))))
    ;; the second argument of the function call doesn't work,
    ;; so here I move the output file manually
    ;; (org-babel-tangle-file file code-path)
    (rename-file (car (org-babel-tangle-file file)) code-path t)))

(defun tangle-code ()
  (make-directory (app-file "output/static/lit/") t)
  (let ((files (directory-files-recursively (app-file "content") "\.lit\.org$")))
    (dolist (file files)
      (tangle-output file))))
