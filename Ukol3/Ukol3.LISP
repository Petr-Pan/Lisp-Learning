;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;

#|

DOKUMENTACE
-----------

TRIDA SEMAPHORE
-----------

Trida semaphore je potomkem tridy picture. Vykresluje se jako obdelnik obsahujici
instance tridy light, ktere reprezentuji svetla semaforu. Barva svetel semaforu
se meni na zaklade faze semaforu, ktera je nastavitelna.

Podobu semaforu lze menit pomoci globalnich promennych *semaphore-light-radius*,
*semaphore-height* a *semaphore-width*.

*semaphore-light-radius*: Nastavuje polomer svetla semaforu. Defaultne 15.

*semaphore-height*:       Nastavuje vysku semaforu o jednom svetle. Celkova vyska semaforu
                          se prizpusobuje poctu svetel na zaklade teto hodnoty. Defaultne
                          nastaveno na 5 + dvojnasobek polomeru svetla.

*semaphore-width*:        Nastavuje sirku semaforu. Defaultne nastaveno na 5 + dvojnasobek
                          polomeru svetla.

UPRAVENE ZDEDENE VLASTNOSTI

Zadne

NOVE VLASTNOSTI

semaphore-type:  Urcuje typ semaforu. Typ semaforu muze byt bud semafor pro chodce (obsahujic
                 cervene a zelene svetlo nebo pro vozidla (cervene, zlute a zelene svetlo). 
                 Defaultne nastaven semafor pro chodce. Mozno pridat vlastni typ semaforu
                 modifikaci globalni promenne *semaphore-programs*. Syntaxe k pridani
                 viz na nasledujicim radku.

Priklad pridani noveho semaforu typu :UK-railway o ctyrech svetlech:
(setf *semaphore-programs*
      (cons '(:UK-railway (:yellow :green :yellow :red) 
              ((nil nil nil t) (nil nil t nil) (t nil t nil) (nil t nil nil)))
            *semaphore-programs*))

Prvni prvek seznamu znaci nazev typu semaforu.
Druhy prvek znaci barvu jednotlivych svetel semaforu pri jejich zapnuti.
Treti prvek je seznam seznamu, jehoz delka znaci pocet fazi semaforu. N-ty podseznam
urcuje stav svetel v n-te fazi semaforu. Faze jsou cislovany od nuly. "t" znaci rozsvicene
svetlo, "nil" znaci zhasnute svetlo. V prikladu vyse je tak napriklad ve fazi 3 rozsviceno
pouze zelene svetlo.


semaphore-phase: Urcuje aktualni fazi semaforu. U semaforu pro chodce znaci hodnota 0
                 cervene svetlo a hodnota 1 znaci zelene svetlo. Semafor pro vozidla ma
                 ctyri faze, od 0 do 3, ktere simuluji faze bezneho semaforu pro vozidla
                 (cervena -> cervena a zluta -> zelena -> oranzova). Defaultni hodnota je 0.

semaphore-phases-list: 
                 Vraci seznam popisu fazi daneho semaforu.

phase-count:     Vraci pocet fazi semaforu. U semaforu pro vozidla 4, u semaforu pro chodce 2.

semaphore-lights:
                 Vraci seznam svetel daneho semaforu.

UPRAVENE ZDEDENE ZPRAVY

Zadne

NOVE ZPRAVY

next-phase:      Zvysi fazi semaforu u jedna. Pokud semafor dosahl posledni faze (u semaforu
                 pro chodce faze 1, u semaforu pro vozidla faze 3), vrati semafor do pocatecni
                 faze. (bez parametru)

set-semaphore-phase phase: 
                 Nastavi fazi semaforu dle zadaneho parametru phase. Prijima hodnoty 0-1
                 pro semafory pro chodce a hodnoty 0-3 pro semafory pro vozidla.

set-semaphore-type type:
                 Nastavi typ semaforu dle zadaneho parametru type. Prijima hodnoty typu semaforu
                 nastavene v globalni promenne *semaphore-programs*. (Blize viz dokumentace
                 k vlastnosti semaphore-type.) V zakladu prijima hodnotu :pedestrian pro nastaveni
                 semaforu pro chodce a hodnotu :vehicle pro nastaveni semaforu pro vozidla.
                          

TRIDA CROSSROADS
-----------

Trida crossroads je potomkem tridy picture. Muze obsahovat libovolne graficke objekty, z nichz
nektere mohou byt semafory. Trida crossroads pak umoznuje jednoduchou spravu fazi jejich
semaforu najednou. Pro spravnou funkcnost tridy crossroads je potreba, po prideleni
semaforu zpravou set-items, nastavit hodnotu vlastnosti program zpravou set-program. 
Pro syntaxi k parametru program viz dokumentaci k vlastnosti program teto tridy.

UPRAVENE ZDEDENE VLASTNOSTI

Zadne

NOVE VLASTNOSTI

semaphores:      Seznam vsech semaforu, jez dana krizovatka obsahuje. Pouze ke cteni. Obsluhu
                 teto vlastnosti obstarava upravena zdedena zprava set-items.

crossroads-phase:
                 Aktualni faze krizovatky. Cisluje se od nuly. Pouze ke cteni. Defaultni hodnota 0.

phase-count:     Pocet fazi krizovatky. Pouze ke cteni. Defaultni hodnota 0.
                 
program:         Urcuje faze semaforu. Jedna se o seznam seznamu, i-ty podseznam programu
                 urcuje stav krizovatky v jeji i-te fazi. Kazdy podseznam musi byt delky
                 rovne poctu semaforu v krizovatce. Cisla v tomto podseznamu pak reprezentuji
                 faze jednotlivych semaforu v dane, i-te fazi. Kuprikladu pro krizovatku
                 o trech semaforech a ctyr fazich by program ((0 0 0) (0 0 1) (1 0 2) (1 1 3))
                 znacil, ze fazi krizovatky 2 by prvni semafor byl ve fazi 1, druhy ve fazi
                 0 a treti ve fazi 2. Defaultne nastaven prazdny seznam.

UPRAVENE ZDEDENE ZPRAVY

set-items items: K predchozi funkcionalite teto zpravy se pridava kontrola zadavaneho seznamu
                 na pritomnost semaforu. Pripadne semafory pak tato zprava nastavi jako seznam 
                 do vlastnosti semaphores dane krizovatky.

NOVE ZPRAVY

set-program list-of-lists:
                 Nastavi program krizovatky dle zadaneho parametru. Syntaxe parametru musi
                 odpovidat strukture popsane v dokumentaci vlastnosti program, jinak
                 bude ohrozena funkcnost chovani dane instance teto tridy.

next-phase:      Posune fazi krizovatky o jeden krok (na dalsi podseznam vlastnosti program).
                 Je-li krizovatka ve sve posledni fazi, posune krizovatku do sve pocatecni
                 faze. (bez parametru)



|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Pomocne funkce na vykresleni tela semaforu
;;;

(defvar *semaphore-light-radius* 15)
(defvar *semaphore-width* (* 2 (+ *semaphore-light-radius* 5)))
(defvar *semaphore-height* (* 2 (+ *semaphore-light-radius* 5)))

(defun quadrilateral (height width)
  (let ((tl (make-instance 'point))
        (tr (make-instance 'point))
        (bl (make-instance 'point))
        (br (make-instance 'point))
        (output (make-instance 'polygon)))
    (set-items output
               (list (move tl 0 0)
                     (move tr 0 height)
                     (move bl width height)
                     (move br width 0)))
    output))

(defun make-light (nth-light color)
  (move (set-radius (set-on-color (make-instance 'light) color) *semaphore-light-radius*) 
        (* 1/2 *semaphore-width*) 
        (+ (* 1/2 *semaphore-height*)
           (* nth-light *semaphore-height*))))

(defun make-list-of-lights (type)
  (let ((colors (semaphore-colors type))
        output)
    (dotimes (i (length (semaphore-colors type)))
      (setf output (cons (make-light i (nth i colors)) output)))
    (reverse output)))

(defun make-semaphore-corpus (lights-count)
  (set-filledp (set-color 
                (quadrilateral (* lights-count *semaphore-height*) *semaphore-width*)
                :gray10)
               t))

;;;
;;; Vlastni trida semaphore
;;;

(defclass semaphore (picture)
  ((semaphore-type :initform :pedestrian)
   (semaphore-phase :initform 0)
   (lights :initform '())))

;;;
;;; Nastavovani programu semaforu
;;;

(defvar *semaphore-programs*
  '((:pedestrian (:red :green) ((t nil) (nil t)))
    (:vehicle (:red :yellow :green) ((t nil nil) (t t nil) (nil nil t) (nil t nil)))))

;;;
;;; Pomocne funkce pro funkcnost programu semaforu

(defun find-program (semaphore-type)
  (let ((result (find-if (lambda (type)
                           (eql (first type) semaphore-type))
                         *semaphore-programs*)))
    result))

(defun semaphore-colors (type)
  (second (find-program type)))

(defun general-semaphore-phases-list (type)
  (third (find-program type)))

;;;
;;; Inicializace
;;;

(defmethod initialize-instance ((sph semaphore) &rest initargs)
  (call-next-method)
  (set-semaphore-type sph :pedestrian)
  sph)

;;;
;;; Vlastnosti
;;;


(defmethod semaphore-type ((semaphore semaphore))
  (slot-value semaphore 'semaphore-type))

(defmethod semaphore-phase ((semaphore semaphore))
  (slot-value semaphore 'semaphore-phase))

(defmethod semaphore-lights ((sph semaphore))
  (slot-value sph 'lights))

(defmethod semaphore-phases-list ((semaphore semaphore))
  (general-semaphore-phases-list (semaphore-type semaphore)))

(defmethod phase-count ((semaphore semaphore))
  (length (semaphore-phases-list semaphore)))

;;;
;;; Zpravy
;;;

(defmethod next-phase ((sph semaphore))
  (set-semaphore-phase sph (rem (+ 1 (semaphore-phase sph)) (length (semaphore-phases-list sph)))))

(defmethod set-semaphore-phase ((sph semaphore) phase)
  (dolist (light (mapcar #'cons (semaphore-lights sph) (nth phase (semaphore-phases-list sph))))
    (set-onp (car light) (cdr light)))
  (setf (slot-value sph 'semaphore-phase) phase)
  sph)

(defmethod set-semaphore-type ((semaphore semaphore) type)
  (let ((lights (make-list-of-lights type)))
  (set-items semaphore (reverse (cons (make-semaphore-corpus (length (semaphore-colors type)))
                                      lights)))
  (setf (slot-value semaphore 'lights) lights) 
  (setf (slot-value semaphore 'semaphore-type) type)
  semaphore))


;;;
;;; Vlastni trida crossroads
;;;

(defclass crossroads (picture)
  ((semaphores :initform '())
   (crossroads-phase :initform 0)
   (phase-count :initform 0)
   (program :initform '())))

;;;
;;; Upravena zdedena zprava
;;;

(defmethod set-items ((cr crossroads) item-list)
  (call-next-method)
  (let ((semaphore-list '()))
    (setf (slot-value cr 'semaphores) (append (reverse (check-for-semaphores item-list)) semaphore-list))
  cr))

;;;
;;; Pomocna funkce pro metodu set-items tridy crossroads

(defun check-for-semaphores (item-list)
  (let ((output '()))
	(dolist (item (copy-list item-list))
		(when (typep item 'semaphore)
			(setf output (cons item output)))
		(when (typep item 'picture)
			(setf output (append (check-for-semaphores (items item)) output))))
        output))

;;;
;;; Vlastnosti
;;;

(defmethod program ((cr crossroads))
  (copy-list (slot-value cr 'program)))

(defmethod crossroads-phase ((cr crossroads))
  (slot-value cr 'crossroads-phase))

(defmethod phase-count ((cr crossroads))
  (slot-value cr 'phase-count))

(defmethod semaphores ((cr crossroads))
  (copy-list (slot-value cr 'semaphores)))

;;;
;;; Zpravy
;;;

(defmethod set-program ((cr crossroads) list-of-lists)
  (setf (slot-value cr 'program) (copy-list list-of-lists))
  (setf (slot-value cr 'phase-count) (list-length list-of-lists))
  cr)

(defmethod set-crossroads-phase ((cr crossroads) phase)
  (dotimes (n (list-length (semaphores cr)))
    (set-semaphore-phase (nth n (semaphores cr))
                         (nth n (nth phase (program cr)))))
  (setf (slot-value cr 'crossroads-phase) phase)
  cr)

(defmethod next-phase ((cr crossroads))
  (set-crossroads-phase cr (rem (+ 1 (crossroads-phase cr)) (- 1 (phase-count cr))))
  cr)


;;; Testy
#|

(setf w (make-instance 'window))
(setf sph (make-instance 'semaphore))
(set-semaphore-type sph :vehicle)
(setf sph2 (move (set-semaphore-type (make-instance 'semaphore) :vehicle) 50 0))
(setf sph3 (move (make-instance 'semaphore) 100 0))

(setf pic (make-instance 'picture))
(setf sph4 (make-instance 'semaphore))
(setf sph5 (move (make-instance 'semaphore) 50 0))
(set-items pic (list sph4 sph5))

(setf cr (make-instance 'crossroads))
(set-items cr (list sph sph2 sph3 (move pic 200 0)))
(set-program cr '((0 0 0 0 1) (0 0 1 0 0) (1 0 2 1 1) (1 1 3 1 1) (0 2 0 0 1) (1 3 0 1 0)))
(set-shape w cr)
(redraw w)

(next-phase cr)
(redraw w)

|#