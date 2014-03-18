(require 'cl)

(defun read-sexp-from-buffer (buffer &optional acc)
  (let ((exp (ignore-errors (read buffer))))
    (if exp
        (read-sexp-from-buffer buffer (nconc acc (list exp)))
      acc)))


(defun read-sexp-from-file (file)
  (with-temp-buffer
      (insert-file-contents file)
      (beginning-of-buffer)
      (read-sexp-from-buffer (current-buffer))))

(defun list-to-log-entity (data)
  (concatenate
   'string
   "\n* " (nth 3 data)
   "\n  <" (nth 0 data) ">"
   "\n  :PROPERTIES:"
   "\n  :CUSTOM_ID: " (symbol-name (nth 1 data))
   "\n  :PUBDATE: <" (nth 0 data) ">"
   "\n  :END:"
   "\n  [[file:" (nth 2 data) "][" (nth 3 data) "]]"
   "\n"))

(defun make-site-log ()
  (mapconcat 'identity
             (mapcar #'list-to-log-entity
                     (read-sexp-from-file (app-file "script/site-log.el"))) "\n"))

(defun test ()
  (message (make-site-log)))

