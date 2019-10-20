#lang racket
(require parser-tools/lex)
(require (prefix-in : parser-tools/lex-sre))

(define calc-lexer
  
  (lexer
   [(:+ (:or (char-range #\a #\z) (char-range #\A #\Z)))
    ; =>
    (cons `(ID ,(string->symbol lexeme))
          (calc-lexer input-port))]
   
   [#\( 
    ; =>
    (cons '(LPAR)
          (calc-lexer input-port))]
   
   [#\)
    ; =>
    (cons '(RPAR) 
          (calc-lexer input-port))]

   [#\[
    ; =>
    (cons '(LB) 
          (calc-lexer input-port))]


    [#\]
    ; =>
    (cons '(RB) 
          (calc-lexer input-port))]


   
   [(:: (:? #\-) (:+ (char-range #\0 #\9)))
    ; =>
    (cons `(INT ,(string->number lexeme))
          (calc-lexer input-port))]
   

   [#\+
    ; =>
    (cons '(OP plus) 
          (calc-lexer input-port))]

    [#\*
    ; =>
    (cons '(OP multi) 
          (calc-lexer input-port))]

     [#\%
    ; =>
    (cons '(OP module) 
          (calc-lexer input-port))]
   
   [whitespace 
    ; =>
    (calc-lexer input-port)]
   
   [(eof)
    '()]))

(calc-lexer (open-input-string "-3 * (2 % 3)"))