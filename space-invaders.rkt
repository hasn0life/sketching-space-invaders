#lang sketching

(define WIDTH 800)
(define HEIGHT 600)

(define bg-color (color 25 25 112))

(struct player (x y))

(define my-ship (player (/ WIDTH 2) (* HEIGHT .9)))

(define left-pressed #f)
(define right-pressed #f)

(define (draw-ship x y)
  (triangle (+ x 30) y
            x (- y 30)
            (- x 30) y ))

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
    (+= my-ship.x 6))
  (when left-pressed
    (-= my-ship.x 6))

  ;; draw
  (background bg-color)
  (draw-ship my-ship.x my-ship.y)
  ;(text (~a " Frame-rate: " frame-rate) 40 50)
  )
