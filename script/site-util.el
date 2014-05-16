
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

(defun app-relative-path (path)
  (if (string-match (concat "^" (regexp-quote app-root-path) "\\(.*\\)$") path)
      (match-string 1 path)
    nil))

(defun relative-resource-for-org-file (resource)
  "Usage:
   org-src/misc/about.org
   ../css/style.css"
  (let ((relative-path (app-relative-path (buffer-file-name (current-buffer)))))
    (if (string-match "org-src/\\(.*\\)/[^/]+\.org" relative-path)
        (concat (mapconcat
                 'identity
                 (mapcar (lambda (_) "..") (split-string (match-string 1 relative-path) "/"))
                 "/") "/" resource)
      resource)))

(defun html-meta-keywords (kws)
  (concat "#+HTML_HEAD: <meta name=\"keywords\" content=\"" (mapconcat 'identity kws ", ") "\"/>"))
