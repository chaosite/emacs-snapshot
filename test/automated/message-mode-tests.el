;;; message-mode-tests.el --- Tests for message-mdoe  -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Free Software Foundation, Inc.

;; Author: João Távora <joaotavora@gmail.com>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file contains tests for message-mode.

;;; Code:
(require 'ert)
(require 'ert-x)

(ert-deftest message-mode-propertize ()
  (with-temp-buffer
    (unwind-protect
        (progn
          (message-mode)
          (insert "here's an opener (\n"
                  "here's a sad face :-(\n"
                  "> here's citing someone with an opener (\n"
                  "and here's a closer ")
          (let ((last-command-event ?\)))
            (ert-simulate-command '(self-insert-command 1)))
          ;; Syntax propertization doesn't kick in batch mode
          (when noninteractive
            (syntax-propertize (point-max)))
          (backward-sexp)
          (should (string= "here's an opener "
                           (buffer-substring-no-properties
                            (line-beginning-position)
                            (point))))
          (forward-sexp)
          (should (string= "and here's a closer )"
                           (buffer-substring-no-properties
                            (line-beginning-position)
                            (point)))))
      (set-buffer-modified-p nil))))

(provide 'message-mode-tests)
;;; message-mode-tests.el ends here
