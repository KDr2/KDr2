
(setq org-confirm-babel-evaluate nil)

(setq org-html-home/up-format
      (concat "<div id=\"org-div-home-and-up\">\n <a accesskey=\"h\" href=\"%s\"> Archives </a>"
              "\n |\n "
              "<a accesskey=\"H\" href=\"%s\"> Categories </a>\n</div>"))

(setq org-html-checkbox-type 'unicode)

(defun sacha/org-html-checkbox (checkbox)
  "Format CHECKBOX into HTML."
  (case checkbox (on "<span class=\"check\">&#x2611;</span>") ; checkbox (checked)
        (off "<span class=\"checkbox\">&#x2610;</span>")
        (trans "<code>[-]</code>")
        (t "")))
(defadvice org-html-checkbox (around sacha activate)
  (setq ad-return-value (sacha/org-html-checkbox (ad-get-arg 0))))


(defvar kdr2-com-html-head-extra (html-head-extra-for-theme))
(defvar kdr2-com-html-preamble (html-preamble-for-theme))
(defvar kdr2-com-html-postamble (html-postamble-for-theme))

(add-hook 'org-export-before-processing-hook
          (lambda (backend) (org-update-all-dblocks)))

(let ((kdr2-com-output-dir (app-file "output/"))
      (kdr2-com-source-dir (app-file "org-src")))
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
           :exclude "README.org\\|.*\.inc\.org\\|.*\.tgl.org"
           )
          ("kdr2-com-rss"
           :base-directory ,kdr2-com-source-dir
           :base-extension "org"
           :publishing-directory ,kdr2-com-output-dir
           :publishing-function (org-rss-publish-to-rss)
           :html-link-home "http://kdr2.com/"
           :html-link-use-abs-url t
           :exclude ".*"
           :include ("misc/site-log.org"))
          ("kdr2-com-static"
           :base-directory ,(app-file "static")
           :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
           :publishing-directory ,kdr2-com-output-dir
           :recursive t
           :publishing-function (org-publish-attachment)
           )
          ("kdr2-com" :components ("kdr2-com-org" "kdr2-com-rss" "kdr2-com-static")))))
