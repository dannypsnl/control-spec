#lang racket
(require racket/path)

(define specs
  (find-files (lambda (path) (path-has-extension? path #"Spec.idr"))
              "test"))

(displayln specs)
