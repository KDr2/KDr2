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
   "\n  [[file:../" (nth 2 data) "][" (nth 3 data) "]]"
   "\n"))

(defun make-site-log ()
  (mapconcat 'identity
             (mapcar #'list-to-log-entity
                     (read-sexp-from-file (app-file "script/site-log.el"))) "\n"))

(defun make-site-archives ()
  (let ((entities (read-sexp-from-file (app-file "script/site-log.el")))
        (archives (make-hash-table))
        (dates '())
        (result '()))
    (dolist (entity entities)
      (let* ((date (substring (nth 0 entity) 0 4))
            (date-entities (gethash date archives nil)))
        (if date-entities
            (puthash date (append date-entities (list entity)) archives)
          (progn
            (puthash date (list entity) archives)
            (setq dates (append dates (list date)))))))
    (dolist (title dates)
      (setq result (append result (list
                                   (format "* %s (%d)" title (length (gethash title archives nil))))))
      (dolist (entity (gethash title archives nil))
        (setq result (append result
                             (list (format "  - [[file:../%s][%s]] %s"
                                           (nth 2 entity)
                                           (nth 3 entity)
                                           (nth 0 entity)))))))
    (mapconcat 'identity result "\n")))

(defun test ()
  (message (make-site-log)))

