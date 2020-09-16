;;; prelude-ts.el --- Emacs Prelude: Typescript programming support.
;;
;; Copyright © 2011-2020 LEE Dongjun
;;
;; Author: LEE Dongjun <redongjun@gmail.com>
;; Version: 1.0.0
;; Keywords: convenience typescript

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Some basic configuration for Typescript development.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'prelude-programming)
(prelude-require-packages '(tide add-node-modules-path company))
(require 'tide)
(require 'typescript-mode)
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(eval-after-load 'typescript-mode
  '(add-hook 'typescript-mode-hook #'add-node-modules-path))

(eval-after-load 'web-mode
  '(add-hook 'web-mode-hook #'add-node-modules-path))

(setq tide-completion-detailed t)
(setq tide-native-json-parsing t)
(setq tide-server-max-response-length 200971520)

(defun prelude-ts-mode-defaults ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(with-eval-after-load 'typescript-mode
  (setq prelude-ts-mode-hook 'prelude-ts-mode-defaults)
  (add-hook 'typescript-mode-hook (lambda () (run-hooks 'prelude-ts-mode-hook))))

(with-eval-after-load 'web-mode
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                (prelude-ts-mode-defaults)))))

(setq company-tooltip-align-annotations t)

(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'typescript-mode)

(flycheck-add-next-checker 'tsx-tide 'javascript-eslint 'append)
(flycheck-add-next-checker 'typescript-tide 'javascript-eslint 'append)

(global-set-key (kbd "M-RET") 'tide-fix)
(global-set-key (kbd "C-x , o") 'tide-organize-imports)
(global-set-key (kbd "C-x , r") 'tide-rename-symbol)

(provide 'prelude-ts)

;;; prelude-ts.el ends here
