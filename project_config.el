(setq org-publish-project-alist
      '(("orgfiles"
         :base-directory "~/repos/gviolato.github.io/org/"
         :base-extension "org"
         :publishing-directory "~/repos/gviolato.github.io/docs/"
         :publishing-function org-tufte-publish-to-html
         :exclude "*.blog.org" ;; regexp
         :headline-levels 3
         :section-numbers nil
	 :with-title t
         :with-toc nil
         :html-preamble t
	 :html-postamble nil)

	("blogfiles"
         :base-directory "~/repos/gviolato.github.io/org/"
         :base-extension "blog.org"
         :publishing-directory "~/repos/gviolato.github.io/docs/"
         :publishing-function org-tufte-publish-to-html
         :exclude "*.blog.org" ;; regexp
         :headline-levels 3
         :section-numbers nil
	 :with-title nil
         :with-toc nil
         :html-preamble t
	 :html-postamble nil
	 :completion-function my-blog-add-comment-section)

        ("images"
         :base-directory "~/repos/gviolato.github.io/assets/images/"
         :base-extension "jpg\\|gif\\|png"
         :publishing-directory "~/repos/gviolato.github.io/docs/assets/images/"
         :publishing-function org-publish-attachment)

        ("other"
         :base-directory "~/repos/gviolato.github.io/assets/css/"
         :base-extension "css\\|el"
         :publishing-directory "~/repos/gviolato.github.io/docs/assets/css/"
         :publishing-function org-publish-attachment)
        ("website" :components ("orgfiles" "blogfiles" "images" "other"))))

(defun print-blog-posts (dir)
  (with-output-to-string
    (dolist (fpath (file-expand-wildcards (format "%s/*blog.org" dir)))
      (princ (format "  - [[file:%s][%s]]\n"
		     (file-name-nondirectory fpath)
		     (org-get-title fpath))))))

(defun my-blog-add-comment-section (plist)
  (let (comment-section)
    (setq comment-section (concat "<div class=\"commentbox\"></div>\n"
				  "<script src=\"https://unpkg.com/commentbox.io/dist/commentBox.min.js\"></script>\n"
				  "<script>commentBox('5734261814460416-proj')</script>\n\n"))
    (dolist (fpath (file-expand-wildcards
		    (format "%s/*blog.html" (plist-get plist ':publishing-directory))))
      (with-temp-buffer
	(insert-file-contents fpath)
	(unless (string-match-p (regexp-quote "commentbox") (buffer-string))
	  (replace-regexp (regexp-quote "</article>") (concat "</article>\n\n" comment-section))
	  (write-file fpath))))))

