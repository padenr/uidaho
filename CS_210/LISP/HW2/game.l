(setq Health 30)
(setq AIHealth 30)
(setq Hand '(
	     (1 nil "C slug" 0 1)
	     (1 nil "int" 1 1)
	     (1 t "++" 0 1)
	     (1 t "^=" 4 0)
	     (2 nil "for (;;)" 2 2)
	     (3 nil "switch" 3 3)
	     (4 nil "array a[100]" 4 4)
	     (4 t "Bus Error Fireball" 6 0)
	     ))


(setq AIHand '(
	       (1 t "Atom" 0 1)
	       (1 t "Car" 1 0)
	       (1 t "Cdr" 2 0)
	       (1 nil "Parenthesis" 1 1)
	       (2 nil "Cons Cell" 2 1)
	       (2 nil "defun" 3 2)
	       (3 t "Mapcar" 4 0)
	       (4 nil "Lisp Monster" 2 6)
	       ))