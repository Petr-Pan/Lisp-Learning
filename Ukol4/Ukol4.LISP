;;;
;;; Trida inspector-window
;;;

(defclass inspector-window (window)
  ((inspected-window :initform nil)))

(defmethod inspected-window ((iw inspector-window))
  (slot-value iw 'inspected-window))

(defmethod set-inspected-window ((iw inspector-window) iedw)
  (setf (slot-value iw 'inspected-window) iedw))


;;;
;;; Trida inspected-window
;;;

(defclass inspected-window (window) ())




;;;
;;; Testy
;;;
(setf iedw (make-instance 'inspected-window))
(setf iw (set-background (make-instance 'inspector-window) :skyblue))
(set-inspected-window iw iedw)
(setf iw-headline (move (make-instance 'text-shape) 0 10))
(set-text iw-headline "Inspector-window")
(set-shape iw iw-headline)