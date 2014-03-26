(setq org-confirm-babel-evaluate nil)

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
