;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"css/org.css\" />")

(setq amarie/html-preamble (concat
"<ul class='nav'>
       <li><a href='index.html'>About</a></li>
       <li><a href='resume.html'>Resume</a></li>
       <li><a href='publications.html'>Publications</a></li>
       <li><a href='communications.html'>Communications</a></li>
 </ul>
 "))

(setq amarie/html-postamble (concat "<div class='footer'>
                                      Last updated %C. <br>
                                      Built with %c.
                                      </div>"))

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :base-directory "./content"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc nil              ;; Don't include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil       ;; Don't include time stamp in file
	     :html-preamble amarie/html-preamble
	     :html-postamble amarie/html-postamble
	     :auto-sitemap t                ; Generate sitemap.org automatically...
	     :sitemap-filename "sitemap.org"  ; ... call it sitemap.org (it's the default)...
	     :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
	     ) 
       (list "org-site:static"
	:base-directory "./content"
	:base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	:publishing-directory "./public"
	:recursive t
	:publishing-function 'org-publish-attachment
	)))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
