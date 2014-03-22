
(defun read-sexp-from-buffer (buffer &optional acc max)
  (if (and (numberp max) (>= (length acc) max))
      acc
    (let ((exp (ignore-errors (read buffer))))
      (if exp
          (read-sexp-from-buffer buffer (nconc acc (list exp)) max)
        acc))))


(defun read-sexp-from-file (file &optional max)
  (with-temp-buffer
      (insert-file-contents file)
      (beginning-of-buffer)
      (read-sexp-from-buffer (current-buffer) nil max)))

