(load-file "~/.emacs.d/init.el")

(defvar kdr2-com-html-head-extra
  "
<link rel=\"stylesheet\" type=\"text/css\"
      href=\"//fonts.googleapis.com/css?family=Libre+Baskerville:400,400italic\">
<link rel=\"stylesheet\" type=\"text/css\"
      href=\"//fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic,600,600italic,700,700italic,800,800italic\">
<link rel=\"alternate\" type=\"application/rss+xml\" title=\"RSS feed for KDr2\" href=\"http://kdr2.com/site-log.xml\">
<script src=\"//code.jquery.com/jquery-1.10.1.min.js\"></script>
<script src=\"//www.google-analytics.com/cx/api.js\"></script>
<script src=\"/script/gat.js\"></script>
<script src=\"/script/site.js\"></script>")

(defvar kdr2-com-html-preamble
  "<div class='nav'>
<ul>
<li id=\"site-name\">KDr2.com</li>
<li><a href=\"/\">Home</a></li>
<li><a target=\"_blank\" href=\"http://github.com/KDr2\"
       class=\"gat-click\" gaid=\"social-link\" ga-action=\"header.click\" ga-label=\"GITHUB\">GitHub</a></li>
<li><a target=\"_blank\" href=\"http://kdr2.net\"
       class=\"gat-click\" gaid=\"social-link\" ga-action=\"header.click\" ga-label=\"TUMBLR\">Tumblr</a></li>
<li><a href=\"/about.html\">About</a></li>
<li><a href=\"/about.html#support_me\" class=\"gat-click\" gaid=\"donate-link\">Support Me</a></li>
<li class=\"search\">
<form method=\"get\" action=\"http://www.google.com/search\">
  <input type=\"text\" name=\"q\" size=\"31\" maxlength=\"255\" value=\"\" />
  <input type=\"hidden\" id=\"sitesearch\" name=\"sitesearch\" value=\"kdr2.com\" />
  <input type=\"submit\" value=\"Search\" class=\"button\" />
</form>
</li>
</ul>
</div>")

(defvar kdr2-com-html-postamble
  "
<p>Copyright &copy; %a, <a href=\"http://creativecommons.org/licenses/by-nc-nd/3.0/\">SOME RIGHTS RESERVED</a>. </p>
<p>Last updated: %C. </p>
<p>Built with %c. </p>
")

(let ((kdr2-com-output-dir (concat (vars-get 'work-dir) "/mine/kdr2-on-web/output"))
      (kdr2-com-source-dir (concat (vars-get 'work-dir) "/mine/kdr2-on-web")))
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
           :exclude "README.org"
           )
          ("kdr2-com-rss"
           :base-directory ,kdr2-com-source-dir
           :base-extension "org"
           :publishing-directory ,kdr2-com-output-dir
           :publishing-function (org-rss-publish-to-rss)
           :html-link-home "http://kdr2.com/"
           :html-link-use-abs-url t
           :exclude ".*"
           :include ("site-log.org"))
          ("kdr2-com-static"
           :base-directory ,(concat kdr2-com-source-dir "/static")
           :base-extension "css\\|js\\|png\\|jpg\\|jpeg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|html"
           :publishing-directory ,kdr2-com-output-dir
           :recursive t
           :publishing-function (org-publish-attachment)
           )
          ("kdr2-com" :components ("kdr2-com-org" "kdr2-com-rss" "kdr2-com-static")))))

(defun export (&optional force)
  (org-publish-project "kdr2-com" force))

(defun force-export ()
  (export t))
