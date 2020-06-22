(global-display-line-numbers-mode)
(setq prelude-format-on-save nil)
(setq prelude-auto-save nil)

(require 'prelude-programming)
(prelude-require-packages '(lsp-ivy add-node-modules-path prettier-js))
(require 'lsp-mode)
(require 'web-mode)
(require 'prettier-js)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(eval-after-load 'typescript-mode
  '(add-hook 'typescript-mode-hook #'add-node-modules-path))

(eval-after-load 'js2-mode
  '(add-hook 'js2-mode-hook #'add-node-modules-path))

(eval-after-load 'web-mode
  '(add-hook 'web-mode-hook #'add-node-modules-path))

(add-hook 'typescript-mode-hook #'lsp-deferred)
(add-hook 'web-mode-hook #'lsp-deferred)

(with-eval-after-load 'typescript-mode
  (defun prelude-ts-mode-defaults ()
    (interactive)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (rainbow-mode +1))
  (setq prelude-ts-mode-hook 'prelude-ts-mode-defaults)
  (add-hook 'typescript-mode-hook (lambda () (run-hooks 'prelude-ts-mode-hook))))

(with-eval-after-load 'web-mode
  (defun my-web-mode-hooks ()
    (interactive)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (rainbow-mode +1))
  (add-hook 'web-mode-hook (lambda () (run-hooks 'my-web-mode-hooks))))

(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'typescript-mode)

(with-eval-after-load 'lsp-mode
  (mapc #'lsp-flycheck-add-mode '(typescript-mode js2-mode web-mode)))

(setq lsp-eslint-server-command
      `("node"
        ,(expand-file-name (car (last (file-expand-wildcards "/Users/alex/.vscode-insiders/extensions/dbaeumer.vscode-eslint-*/server/out/eslintServer.js"))))
        "--stdio"))

(setq lsp-enable-semantic-highlighting t)
(setq lsp-semantic-tokens-apply-modifiers t)
;(setq lsp-document-sync-method lsp--sync-none)
(setq lsp-lens-auto-enable t)

(defun run-prettier-on-save ()
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'typescript-mode-hook 'prettier-js-mode))

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
