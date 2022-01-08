#lang sketching

(define WIDTH 800)
(define HEIGHT 600)
(define SHIP-SIZE 30)
(define INVADER-SIZE 40)
(define LASER-SPEED 200)
(define LASER-SIZE 20)
(define LASER-T-LIM .5)

(define bg-color (color 25 25 112))

(struct player (x y))
(struct invader (x y))
(struct laser (x y))

(define my-ship (player (/ WIDTH 2) (* HEIGHT .9)))
(define player-lasers '())

(define (setup-invasion row col)
  (define c-dist (round (/ WIDTH (+ 2 col))))
  (define v-dist (* 2 INVADER-SIZE ))
  (for*/list ([r (in-range row)]
              [c (in-range col)])
    (invader (* c-dist (add1 c)) (* .75 v-dist (add1 r)) )))

(define invaders-list (setup-invasion 4 8))

(define left-pressed #f)
(define right-pressed #f)
(define shoot-pressed #f)

(define prev-millis 0)
(define laser-timer LASER-T-LIM)

;; drawing functions
(define (draw-ship x y)
  (fill "gray")
  (triangle (+ x SHIP-SIZE) y
            x (- y SHIP-SIZE)
            (- x SHIP-SIZE) y ))

(define (draw-laser x y)
  (ellipse-mode 'center)
  (fill "orange")
  (ellipse x y (/ LASER-SIZE 2) LASER-SIZE))

(define (draw-invader x y)
  (ellipse-mode 'center)
  (fill "gray")
  (ellipse x y INVADER-SIZE INVADER-SIZE))

;; keyboard functions
(define (pressed-func is-set?)
  (when (equal? key 'right)
    (set! right-pressed is-set?))
  (when (equal? key 'left)
    (set! left-pressed is-set?))
  (when (equal? key #\space)
    (set! shoot-pressed is-set?)))

(define (on-key-pressed)
  (pressed-func #t))

(define (on-key-released)
  (pressed-func #f))

;; physics functions

;;circle circle collision
(define (hit? x1 y1 x2 y2 dist)
  (<= (sqrt (+ (sqr (- x1 x2))
               (sqr (- y1 y2))))
      dist))
  

;; setup
(define (setup)
  (size WIDTH HEIGHT)
  (background bg-color)
  (set-frame-rate! 30)
  (no-stroke)
  )


;; main function
(define (draw)
  
  (define current-millis (millis))
  (define dt (/ (- current-millis prev-millis) 1000.0))
  (set! prev-millis current-millis)
  
  (+= laser-timer dt)
  
  ;; controls
  (when right-pressed
    (when (< (+ my-ship.x SHIP-SIZE) WIDTH)
      (+= my-ship.x 6)))
  (when left-pressed
    (when (> (- my-ship.x SHIP-SIZE) 0)
      (-= my-ship.x 6)))
  (when shoot-pressed
    (when (> laser-timer LASER-T-LIM)
      (:= laser-timer 0)
      (:= player-lasers
          (cons (laser my-ship.x (- my-ship.y SHIP-SIZE))  player-lasers))))

  ;; physics
  (for ([i (in-list player-lasers)])
    (-= i.y (* LASER-SPEED dt))
    (when (< i.y 0)
      (when (< (length player-lasers) 3)
        (:= player-lasers (remove i player-lasers)))))

  (for* ([i (in-list player-lasers)]
        [j (in-list invaders-list)])
    ;; hit distance is the radius of both the laser and the ship added together
    (when (hit? i.x i.y j.x j.y
                (+ (/ LASER-SIZE 4) (/ INVADER-SIZE 2)))
      (:= invaders-list (remove j invaders-list))
      (:= player-lasers (remove i player-lasers))))
  
  ;; draw
  (background bg-color)
  (draw-ship my-ship.x my-ship.y)
  (for ([i (in-list invaders-list)])
      (draw-invader i.x i.y))
  (for ([i (in-list player-lasers)])
      (draw-laser i.x i.y))
  
  (fill "orange")
  (text (~a " Frame-rate: " frame-rate) 40 50)
  )
