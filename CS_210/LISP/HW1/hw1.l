;;; Paden Rumsey, CS 210 HW#1, Lisp Assignment

;; foo function
;; the simple foo function it checks to see if
;; n is an integer and if it is it then executes the
;; next conditional to check if its less than one. If it is
;; it returns one. if not it runs the next equation. 
;; returns nill if not integer

(defun foo(n)
  (if (integerp n)
    (if (<= n 1) 1
       (* (foo (- n 1)) (/ n 2)))
     nil
    )
)


;;sign sum. I used a helper funciton on this one. It was
;; so I could check to see if the parameter was actually a list
;; while also being able to create a terminating case. if the
;; parameter is a list. Sum walk gets called. There are two conditionals
;; that add zeros. ONe of them checks to see if the element is a number. THe
;; other checks to see if its zero. The other two check to see whether the element
;; is positive or negative

(defun signsum(L)
  (if (listp L)
      (sum-walk L)
      nil
      )
  )


(defun sum-walk(L)
  (if (null L) 0
    (cond
       ((not(numberp (car L))) (+ (signsum (cdr L)) 0 ))
       ((zerop (car L)) (+ (signsum (cdr L)) 0))
       ((> (car L) 0) (+ (signsum (cdr L)) 1))
       ((< (car L) 0) (- (signsum (cdr L)) 1))
       )
    )
)

;; squared evens. This one also calls a helper function for the same reason
;; as the previous function, to aid with the terminating case. The conditionals
;; check to see if its an integer, nil, odd or even
(defun squaredevens(L)
  (if(listp L)
      (square-list L)
      nil
      )
  )

(defun square-list(L)
  (if (null L) nil
    (cond
     ((not (integerp (car L))) 
      (cons nil (square-list(cdr L))))
     ((evenp (car L)) 
      (cons (* (car L) (car L)) (square-list(cdr L))))
     ((oddp (car L))
      (cons nil (square-list(cdr L))))
     )
    )
  )

;;pretty simple. NO helper function. if the list is null it returns zero to get
;; correct addition in the end. If it isn't then the function calls the next
;; element until it gets to the end. when it does it checks the car of the first
;; and second elements in the sub list

(defun polyval(L x)
  (if(null L) 0
    (progn
      (+ 
       (polyval (cdr L) x)
       (* (car (car L)) (expt x (car (cdr (car L)))))
       )
      )
    )
  )

;; hasp. Lots of conditionals here. if checks to see if we are 
;; at the end of the list. or if the car equals what we want or if 
;; the previous recursive function passed a true. or if there is a 
;; sublist. When boiled down it traverses the list and checks for 
;; a variety of conditions to get the right answer. 

(defun hasp(LL n)
  (cond
   ((null LL) nil)    ;;returns if at end of branch in list
   ((equal (car LL) n) t) ;;if the car equals what we are looking for
   ((equal (hasp(cdr LL) n) t) t) ;;if true was passed in previous recursive call
   ((not(listp (car LL))) ;;if the car doesnt point to a list does it point to what we 
                            ;; are looking for
    (if (equal (car LL) n) t)) 
   ((equal (hasp (car LL) n) t) t) ;; did hasp return true in another recursive call
  )
)


;; ncons. Tests to see if the list is null. This is the base case. If not nill then
;; it tests to see if the car is pointing to a cons. if it is it recurses into that
;; car. If not it follows the cdr further along the list. It sums it all up when it
;; goes back out. 

(defun ncons(LL)
  (if (null LL) 0
    (if (consp (car LL)) 
	(+ (ncons (car LL)) (ncons (cdr LL)) 1)
      (+ (ncons (cdr LL)) 1))
    )
  )
  

;; nvowels. No recursion here. The count functionis built in lisp. It iterates through
;; the string counting all the vowels in the string. It adds all those together. 

(defun nvowels(s)
  (+ (count #\a s) 
     (count #\e s) 
     (count #\i s)
     (count #\u s)
     (count #\o s)
  )
)

;; bit2list. this one pulls of the front of the string and then it recurses into the
;; string. when it gets down to length 0 it recurses out. if the symbol is a 1 it will
;; add a t the list. If not it adds a nil. It uses the subseq to keep shortening the list
;; during recursion. 

(defun bit2list(s)
  (if (equal (length s) 0) nil
     (if (equal (char s 0) #\1)
	 (cons t (bit2list (subseq s 1 (length s))))
         (cons nil (bit2list (subseq s 1 (length s))))
	 )
     )
)