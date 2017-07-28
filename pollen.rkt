#lang racket

(require pollen/decode txexpr)
(provide (all-defined-out))

; (define exclusion-mark-attr '(decode "exclude"))
(define (root . elements)
    `(doc ,@(decode-elements elements

    #:txexpr-elements-proc decode-paragraphs
    #:exclude-tags '(centered-ascii-figure table)
    )))

(define (chapter #:index index . elements)
    `(div ((class "chapter-header"))
        (div ((class "chapter-number")) ,index)
        (h1 ,@elements)))

(define (section . elements)
    `(h2 ,@elements))

(define (warning . elements)
    `(div ((class "warning-container")) (h2 "Warning!") (warning ,@elements)))

(define (link url . elements)
    `(a ((href ,url) (target "_blank")) ,@elements))

(define (td-ellipsis)
    `(td ((class "ellipsis"))))

(define (td-invisible . elements)
    `(td ((class "invisible")) ,@elements))

(define (td-annotation . elements)
    `(td ((class "annotation")) ,@elements))

(define (td-highlight #:background-color bg-color . elements)
    `(td (span ((style ,(string-append "background-color: " bg-color ";")) (class "highlight")) ,@elements)))

(define (memory-table-h-addresses . elements)
    `(tr ((class "memory-table-h-addresses")) ,@elements))

(define (memory-table-h-cells . elements)
    `(tr ((class "memory-table-h-cells")) ,@elements))

(define (math . elements)
    `(simple-math ,@elements))

(define (centered-ascii-figure . elements)
    `(div ((class "centered-container")) (ascii-figure ,@elements)))

(define (exponent . elements)
    `(sup ,@elements))
