
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

(defun html-youtube-video (id)
  (concat "#+BEGIN_HTML\n<center>"
          "<iframe width=\"640\" height=\"510\" src=\"//www.youtube.com/embed/"
          id
          "\" frameborder=\"0\" allowfullscreen></iframe>"
          "</center>\n#+END_HTML\n"))

;; example:
;; http://res.cloudinary.com/kdr2/image/upload/c_scale,w_400/img-kdr2-com/2010/12/pyc_format_example_0.png.png
(defun site-image (path width title)
  (let* ((width (or width 600))
         (title (or title ""))
         (url
          (concat "http://res.cloudinary.com/kdr2/image/upload/c_scale,w_" (number-to-string width)
                  "/img-kdr2-com/" path))
         (original-url
          (concat "http://res.cloudinary.com/kdr2/image/upload/" "img-kdr2-com/" path)))
    (concat "#+BEGIN_HTML\n<center class=\"image-container\">"
            "<a target=\"_blank\" href=\"" original-url "\">"
            "<img src=\"" url "\" style=\"width: auto; height: auto; max-width: 600px; \">"
            "</a><br/>" title "</center>\n#+END_HTML\n")))

(defun inc-code (path lang)
  (let* ((lang (or lang ""))
         (file (app-file (concat "code-src/" path)))
         (code (with-temp-buffer
                 (insert-file-contents file)
                 (buffer-string))))
    (concat "#+BEGIN_SRC " lang "\n"
            code "\n#+END_SRC\n\n"
            "#+BEGIN_HTML\n<center>"
            "<a target=\"_blank\" href=\"https://github.com/KDr2/kdr2-on-web/blob/master/code-src/" path "\">On Github</a>"
            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            "<a target=\"_blank\" href=\"https://raw.githubusercontent.com/KDr2/kdr2-on-web/master/code-src/" path "\">Raw File</a>"
            "</center>\n#+END_HTML\n")))

(defun org-files-under-dir (dir)
  (let* ((dir (or dir (file-name-directory (buffer-file-name))))
         (cmd (format "find %s -type f -name \"*.org\"" dir))
         (files (split-string (shell-command-to-string cmd) "\n")))
    (mapconcat 'identity
               (mapcar (lambda (f)
                         (if (or (zerop (length f))
                                 (string-match "\\.inc\\.org$" f))
                             ""
                           (let* ((rf (replace-regexp-in-string (concat "^" dir) "" f)))
                             (format "- [[file:%s][%s]]" rf rf)))) files) "\n")))
