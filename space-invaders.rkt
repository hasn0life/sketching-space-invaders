#lang sketching

(define WIDTH 800)
(define HEIGHT 600)

(define bg-color (color 25 25 112))

(define (setup)
  (size WIDTH HEIGHT)
  (background bg-color)
  (set-frame-rate! 30)
  (no-stroke)
  )


(define (draw)
  (background bg-color)
  
  ;(text (~a " Frame-rate: " frame-rate) 40 50)
  )
