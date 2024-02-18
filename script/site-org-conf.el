(setq org-confirm-babel-evaluate nil)

(setq org-html-home/up-format
      (concat "<div id=\"org-div-home-and-up\">\n"
              "<a accesskey=\"h\" href=\"%s\"> Archives </a>"
              "\n |\n "
              "<a accesskey=\"H\" href=\"%s\"> Categories </a>\n</div>"))

(setq org-html-checkbox-type 'unicode)

(defun unicode-for-org-html-checkbox (checkbox)
  "Format CHECKBOX into HTML."
  (case checkbox (on "&#x22A0;")
        (off "&#x25FB;")
        (trans "&#x22A1;")
        (t "")))
(defadvice org-html-checkbox (around unicode-checkbox activate)
  (setq ad-return-value (unicode-for-org-html-checkbox (ad-get-arg 0))))

(defadvice org-html-paragraph (before org-html-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let* ((orig-contents (ad-get-arg 1))
         (reg-mb "[[:multibyte:]]")
         (fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-mb
                                  "\\) *\n *\\(" reg-mb "\\)")
                          "\\1\\2" orig-contents)))
    (ad-set-arg 1 fixed-contents)))

(defvar kdr2-com-html-head-extra (html-head-extra-for-theme))
(defvar kdr2-com-html-preamble (html-preamble-for-theme))
(defvar kdr2-com-html-postamble (html-postamble-for-theme))

(add-hook 'org-export-before-processing-hook
          (lambda (backend) (org-update-all-dblocks)))

(let ((kdr2-com-output-dir (app-file "output/"))
      (kdr2-com-source-dir (app-file "content")))
  (setq org-publish-project-alist
        `(("kdr2-com-org"
           :base-directory ,kdr2-com-source-dir
           :base-extension "org"
           :publishing-directory ,kdr2-com-output-dir
           :recursive t
           :publishing-function (org-html-publish-to-html)
           :html-head-extra ,kdr2-com-html-head-extra
           :html-preamble ,kdr2-com-html-preamble
           :html-postamble ,kdr2-com-html-postamble
           :headline-levels 3
           :auto-preamble t
           :exclude "README.org\\|.*\.inc\.org\\|.*\.lit\.org")
          ("kdr2-com-rss"
           :base-directory ,kdr2-com-source-dir
           :base-extension "org"
           :publishing-directory ,kdr2-com-output-dir
           :publishing-function (org-rss-publish-to-rss)
           :html-link-home "http://kdr2.com/misc/"
           :html-link-use-abs-url t
           :exclude ".*"
           :include ("misc/site-log.org"))
          ("kdr2-com-static"
           :base-directory ,(app-file "static")
           :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
           :publishing-directory ,(concat kdr2-com-output-dir "static/")
           :recursive t
           :publishing-function (org-publish-attachment))
          ;; rss disabled
          ("kdr2-com" :components ("kdr2-com-org" "kdr2-com-static")))))
