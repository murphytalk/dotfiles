;(setq my-font "Droid Sans Mono Slashed for Powerline-12")
(setq org-directory "~/Dropbox/org-mode")
(setq deft-directory org-directory)

(setq org-roam-directory (file-truename "~/Dropbox/org-mode"))
(setq org-roam-dailies-directory (file-truename "~/Dropbox/org-mode/journals"))
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry "* %?" :target (file+head "%<%Y_%m_%d>.org" "#+title: %<%Y-%m-%d>\n"))))
;(org-roam-setup)

;gentoo specific
(add-to-list 'load-path "/usr/share/emacs/site-lisp/ebuild-mode")
(autoload 'ebuild-mode "ebuild-mode"
  "Major mode for Portage .ebuild and .eclass files." t)
(autoload 'gentoo-newsitem-mode "gentoo-newsitem-mode"
  "Major mode for Gentoo GLEP 42 news items." t)

(add-to-list 'auto-mode-alist
	     '("\\.\\(ebuild\\|eclass\\|eblit\\)\\'" . ebuild-mode))
(add-to-list 'auto-mode-alist
	     '("/[0-9]\\{4\\}-[01][0-9]-[0-3][0-9]-.+\\.[a-z]\\{2\\}\\.txt\\'"
	       . gentoo-newsitem-mode))
(add-to-list 'interpreter-mode-alist '("runscript" . sh-mode))
(modify-coding-system-alist 'file "\\.\\(ebuild\\|eclass\\|eblit\\)\\'" 'utf-8)
