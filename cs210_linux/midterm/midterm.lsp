
(defun flatten (L)
  (cond
   ((null l) nil)
   ((atom l) (list l))
   (t (loop for a in l appending (flatten a)))))
