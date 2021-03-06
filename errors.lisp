(defpackage #:ragno/errors
  (:use #:cl)
  (:import-from #:ragno/response
                #:response-uri
                #:response-status)
  (:import-from #:quri
                #:render-uri)
  (:export #:ragno-error
           #:ragno-fetch-error
           #:ragno-parse-error
           #:ragno-concurrency-limit))
(in-package #:ragno/errors)

(define-condition ragno-error (error) ())

(define-condition ragno-fetch-error (ragno-error)
  ((response :initarg :response))
  (:report (lambda (condition stream)
             (let ((response (slot-value condition 'response)))
               (format stream "Fetch failed from '~A' (Code=~A)"
                       (quri:render-uri (response-uri response))
                       (response-status response))))))

(define-condition ragno-concurrency-limit (ragno-error)
  ((uri :initarg :uri)
   (retry-after :initarg :retry-after
                :reader retry-after))
  (:report (lambda (condition stream)
             (format stream "Failed to fetch ~S because of the concurrency limit. Retry after ~S secs."
                     (slot-value condition 'uri)
                     (slot-value condition 'retry-after)))))
