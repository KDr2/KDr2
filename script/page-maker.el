(require 'cl)

(setq site-metadata-file "script/site-metadata.el")

(defvar dir-to-category-names
  '(("tech" . "Tech")))

(defun path-to-cat (path)
  (if (string-match "\\(.*\\)/[^/]+$" path)
      (let ((path-parts (split-string (match-string 1 path) "/")))
        (mapconcat (lambda (part)
                     (let ((cat-name (assoc part dir-to-category-names)))
                       (if cat-name
                           (cdr cat-name)
                         (capitalize part))))
                   path-parts " > "))
    "Default"))

(defun title-to-id (title)
  (replace-regexp-in-string "[^[:alnum:]]+" "-" (downcase title)))

(defun list-to-log-entity (data)
  (concatenate
   'string
   "\n* " (nth 4 data)
   "\n  <" (nth 0 data) ">"
   "\n  :PROPERTIES:"
   "\n  :CUSTOM_ID: " (symbol-name (nth 2 data))
   "\n  :PUBDATE: <" (nth 0 data) ">"
   "\n  :END:"
   "\n  [[file:../" (nth 3 data) "][" (nth 4 data) "]]"
   "\n"))

(defun make-site-log ()
  (mapconcat 'identity
             (mapcar #'list-to-log-entity
                     (read-sexp-from-file (app-file site-metadata-file))) "\n"))


(defun classify-site-entities (key-func format-func)
  (let ((entities (read-sexp-from-file (app-file site-metadata-file)))
        (bucket (make-hash-table :test 'equal))
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
      (setq result (append result (list
                                   (format "  :PROPERTIES:\n  :CUSTOM_ID: %s\n  :END:" (title-to-id title)))))
      (dolist (entity (gethash title bucket nil))
        (setq result (append result
                             (list (funcall format-func entity))))))
    (mapconcat 'identity result "\n")))

(defun make-site-archives ()
  (classify-site-entities
   (lambda (entity) (substring (nth 0 entity) 0 4))
   (lambda (entity) (format "  - %s [%s] [[file:../%s][%s]]"
                            (substring (nth 0 entity) 0 10)
                            (nth 1 entity)
                            (nth 3 entity)
                            (nth 4 entity)))))

(defun make-site-cats ()
  (classify-site-entities
   (lambda (entity) (path-to-cat (nth 3 entity)))
   (lambda (entity) (format "  - %s [%s] [[file:../%s][%s]]"
                            (substring (nth 0 entity) 0 10)
                            (nth 1 entity)
                            (nth 3 entity)
                            (nth 4 entity)))))

(defun test ()
  (message (make-site-log)))
