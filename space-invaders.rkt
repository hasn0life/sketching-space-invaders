#lang sketching

(define WIDTH 800)
(define HEIGHT 600)

(define bg-color (color 25 25 112))

(struct player (x y))

(define my-ship (player (/ WIDTH 2) (* HEIGHT .9)))

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


(define (draw)
  ;; controls
  (when (and key-pressed (equal? key 'right))
    (+= my-ship.x 6))
  (when (and key-pressed (equal? key 'left))
    (-= my-ship.x 6))

  ;; draw
  (background bg-color)
  (draw-ship my-ship.x my-ship.y)
  ;(text (~a " Frame-rate: " frame-rate) 40 50)
  )
