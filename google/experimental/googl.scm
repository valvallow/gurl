(define-module google.experimental.googl
  (use rfc.http)
  (use rfc.json)
  (use rfc.uri)
  (export shorten-url expand-url))
(select-module google.experimental.googl)

(define *goo.gl-server* "www.googleapis.com")
(define *goo.gl-request-uri* "/urlshortener/v1/url")

(define (shorten-url url api-key)
  (body->json
   (^ _ (goo.gl-request http-post url api-key
                        :msg (construct-json-string
                              `(("longUrl" . ,url)))))))

(define (expand-url url api-key)
  (body->json
   (^ _ (goo.gl-request http-get url api-key
                        :more-req-uri #`"&shortUrl=,|url|"))))

(define (body->json req)
  (receive (status header body)
      (req)
    (parse-json-string body)))

(define (goo.gl-request method url api-key
                        :key (more-req-uri "")(msg #f))
  (let1 req-uri (string-append
                 *goo.gl-request-uri*
                 "?key=" api-key more-req-uri)
  (if msg
      (method *goo.gl-server* req-uri
              msg
              :content-type "application/json"
              :secure #t)
      (method *goo.gl-server* req-uri
              :secure #t))))

(provide "google/experimental/googl")
