
(defvar site-theme "theme-0")

(defun dynamic-header-css-for-theme (&optional theme)
  (let ((current-theme (or theme site-theme)))
    (concat "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\""
            (relative-resource-for-org-file (concat "static/" current-theme  "/style.css"))
            "\" />")))

(defun dynamic-header-link-for-theme (&optional theme)
  (let ((current-theme (or theme site-theme)))
    (concat "#+HTML_LINK_HOME: " (relative-resource-for-org-file "misc/categories.html")
            "\n"
            "#+HTML_LINK_UP: " (relative-resource-for-org-file "misc/archives.html"))))

(defun dynamic-header-for-theme (&optional theme)
  (let ((current-theme (or theme site-theme)))
    (concat (dynamic-header-css-for-theme current-theme)
            "\n"
            (dynamic-header-link-for-theme current-theme))))

(defun org-dblock-write:inc-file (params)
  (let ((file (plist-get params :file)))
    (insert (concat "#+INCLUDE: "
                    (relative-resource-for-org-file (concat  "include/" file))))))

(defmacro def-theme-element (element-getter file-name)
  `(defun ,element-getter (&optional theme)
     (let ((current-theme (or theme site-theme)))
       (with-temp-buffer
         (insert-file-contents (concat app-root-path "static/" current-theme "/" ,file-name))
         (buffer-string)))))

(def-theme-element html-head-extra-for-theme "head-extra.html")
(def-theme-element html-preamble-for-theme "preamble.html")
(def-theme-element html-postamble-for-theme "postamble.html")
