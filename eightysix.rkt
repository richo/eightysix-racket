#lang racket
(define wsurl (getenv "AGENT99_WEBSOCKET_URL"))
(cond ((not wsurl)
    (displayln "undefined environment variable AGENT99_WEBSOCKET_URL")
    (exit 1)))

(require net/websocket/client)
(require net/url)

(define enscripten
  (lambda (name)
    (string-append "./" name ".sh")))

(define (handle line)
  (displayln (string-append ">> " line))
  (cond ((file-exists? (enscripten line)) (system (enscripten line)))))

(define (start-client url)
  (call/cc (lambda (cc)
    (define-values (sock) (ws-connect url))
    (let eventloop ()
      (let ((line (ws-recv sock)))
        (if (eof-object? line)
            (cc)
            (handle line)))
    (eventloop)))))

(define (main argv)
  (letrec ((mainloop (lambda ()
      (start-client (string->url wsurl))
      (mainloop))))
    (mainloop)))

(main '())
