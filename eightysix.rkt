#lang racket
(define wsurl (getenv "AGENT99_WEBSOCKET_URL"))
(require net/websocket/client)
(require net/url)

(define enscripten
  (lambda (name)
    (string-append "./" name ".sh")))

(define (handle line)
  (displayln (string-append ">> " line))
  (cond ((file-exists? (enscripten line)) (system (enscripten line)))))

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



