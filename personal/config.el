(global-display-line-numbers-mode)
(setq prelude-format-on-save nil)
(setq prelude-auto-save nil)

(prelude-require-packages '(lsp-ivy prettier-js))

(require 'prettier-js)

(defun run-prettier-and-then-save ()
  (interactive)
  (prettier-js)
  (save-buffer))

(global-set-key (kbd "s-1") 'prettier-js)
(global-set-key (kbd "s-2") 'run-prettier-and-then-save)

(desktop-save-mode 1)
(super-save-mode -1)
(scroll-bar-mode -1)

(global-set-key (kbd "s-b") 'helm-buffers-list)
