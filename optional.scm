;;;; Preston Thompson and Ari Vogel
;;;; Optional
;;;; May 5, 2014

;; `(a (?:optional ((?:choice b c) d)))
;;
;; matches a
;; matched abd
;; matches acd

(define (match:optional? pattern)
  (and (pair? pattern)
       (eq? (car pattern) '?:optional)))

(define (match:optional . match-combinators)
  (define (optional-match network start-node end-node)
    (let ((connected-network ((apply match:list match-combinators)
			     network
			     start-node
			     end-node)))
      (add-edge
       connected-network
       start-node
       end-node
       (lambda (data step-expand) 
	 (not step-expand))
       #t)
      connected-network))
  optional-match)

(define (match:optional-combinators pattern) (cdr pattern))

(defhandler match:->combinators
  (lambda (pattern)
    (apply match:optional
	   (map match:->combinators (match:optional-combinators pattern))))
  match:optional?)

#|

(match:maker 
 (new-network `(?:optional a b c))
 `(a b c))
;Value: #t

(match:maker 
 (new-network `(?:optional a b c))
 `())
;Value: #t

(match:maker 
 (new-network `(?:optional a b c))
 `(a b c d a b c))
;Value: #t

(match:maker 
 (new-network `(b (?:optional a) c))
 `(b a c))
;Value: #t

(match:maker 
 (new-network `(b (?:optional a) c))
 `(b c))
;Value: #t

(match:maker 
 (new-network `(b (?:optional a) c))
 `(b d c))
;Value: #f

|#

#|
((match:->combinators
  `((?:optional a) a))
 `((a a))
 `()
 (lambda (d n)
   (pp `(succeed ,d ,n))
   #f))
(succeed () 1)
;Value: #f

((match:->combinators
  `((?:optional b) a))
 `((b a))
 `()
 (lambda (d n)
   (pp `(succeed ,d ,n))
   #f))
(succeed () 1)
;Value: #f

((match:->combinators
  `((?:optional b) a))
 `((a))
 `()
 (lambda (d n)
   (pp `(succeed ,d ,n))
   #f))
(succeed () 1)
;Value: #f

(define pattern `(,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o ,o a a a a a a a a a a a a a a a a a a a a a a))
;Value: pattern

((match:->combinators pattern)
 `((a a a a a a a a a a a a a a a a a a a a a a))
 `()
 (lambda (d n)
   (pp `(succeed ,d ,n))
   #f))
(succeed () 1)
;Value: #f
; took 3 minutes 15 seconds

|#











































































