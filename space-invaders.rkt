#lang sketching

(define WIDTH 800)
(define HEIGHT 600)
(define SHIP-SIZE 30)

(define bg-color (color 25 25 112))

(struct player (x y))

(define my-ship (player (/ WIDTH 2) (* HEIGHT .9)))

(define left-pressed #f)
(define right-pressed #f)

(define (draw-ship x y)
  (triangle (+ x SHIP-SIZE) y
            x (- y SHIP-SIZE)
            (- x SHIP-SIZE) y ))

(define (draw-invader x y)
  (ellipse-mode 'center)
  (fill "gray")
  (ellipse x y 60 20))

(define (setup)
  (size WIDTH HEIGHT)
  (background bg-color)
  (set-frame-rate! 30)
  (no-stroke)
  )

(define (pressed-func is-set?)
  (when (equal? key 'right)
    (set! right-pressed is-set?))
  (when (equal? key 'left)
    (set! left-pressed is-set?)))

(define (on-key-pressed)
  (pressed-func #t))

(define (on-key-released)
  (pressed-func #f))

(define (draw)
  
  ;; controls
  (when right-pressed
    (when (< (+ my-ship.x SHIP-SIZE) WIDTH)
      (+= my-ship.x 6)))
  (when left-pressed
    (when (> (- my-ship.x SHIP-SIZE) 0)
      (-= my-ship.x 6)))

  ;; draw
  (background bg-color)
  (draw-ship my-ship.x my-ship.y)
  (draw-invader (/ WIDTH 2) (/ HEIGHT 2))
  ;(text (~a " Frame-rate: " frame-rate) 40 50)
  )
