(require 'cl)

(setq site-metadata-file "script/site-metadata.el")

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
                     (read-sexp-from-file (app-file site-metadata-file))) "\n"))


(defun classify-site-entities (key-func format-func)
  (let ((entities (read-sexp-from-file (app-file site-metadata-file)))
        (bucket (make-hash-table))
        (keys '())
        (result '()))
    (dolist (entity entities)
      (let* ((key (funcall key-func entity))
             (key-entities (gethash key bucket nil)))
        (if key-entities
            (puthash key (append key-entities (list entity)) bucket)
          (progn
            (puthash key (list entity) bucket)
            (setq keys (append keys (list key)))))))
    (dolist (title keys)
      (setq result (append result (list
                                   (format "* %s (%d)" title (length (gethash title bucket nil))))))
      (dolist (entity (gethash title bucket nil))
        (setq result (append result
                             (list (funcall format-func entity))))))
    (mapconcat 'identity result "\n")))

(defun make-site-archives ()
  (classify-site-entities
   (lambda (entity) (substring (nth 0 entity) 0 4))
   (lambda (entity) (format "  - %s [[file:../%s][%s]]"
                            (substring (nth 0 entity) 0 10)
                            (nth 2 entity)
                            (nth 3 entity)))))

(defun path-to-cat (path)
  (if (string-match "\\(.*\\)/[^/]+$" path)
      (let ((path-parts (split-string (match-string 1 path) "/")))
        (mapconcat #'capitalize path-parts " > "))
    "Default"))

(defun make-site-cats ()
  (classify-site-entities
   (lambda (entity) (path-to-cat (nth 2 entity)))
   (lambda (entity) (format "  - %s [[file:../%s][%s]]"
                            (substring (nth 0 entity) 0 10)
                            (nth 2 entity)
                            (nth 3 entity)))))

(defun test ()
  (message (make-site-log)))
