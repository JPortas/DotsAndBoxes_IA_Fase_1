;;;; puzzle.lisp
;;;; Lógica do dominio
;;;; Autor: Lucas Freixieiro e João Portas


;;; Tabuleiro
(defun tabuleiro-teste ()
  "Retorna um tabuleiro 3x3 (3 arcos na vertical por 3 arcos na horizontal)"
	'(
		((0 0 1 0) (1 1 1 1) (0 0 1 1) (0 0 1 1) (0 0 1 1))
		((0 0 1 1) (0 0 1 1) (1 1 1 1) (1 0 1 1) (0 1 1 1))
	)
)

;;; Exercicios
(defun get-arcos-horizontais (board) 
	(cond
		(
			(null board)
			nil
		)
		(T
			(car board)
		)
	)
)

(defun get-arcos-verticais (board)
	(cond
		(
			(null board)
			nil
		)
		(T
			(cadr board)
		)
	)
)

(defun get-arco-na-posicao (numero-da-lista posicao-na-lista listas)
	(cond
		(
			(or (null listas) (< numero-da-lista 1) (< posicao-na-lista 1))
			nil
		)
		(T
			(nth (- posicao-na-lista 1) (nth (- numero-da-lista 1) listas))
		)
	)
)

(defun substituir (indice lista &optional (x 1))
	(cond
		(
			(or (null lista) (< indice 1))
			nil
		)
		(
			(= indice 1)
			(cons x (cdr lista))
		)
		(T
			(cons (car lista) (substituir (- indice 1) (cdr lista) x))
		)
	)
)

(defun arco-na-posicao (numero-da-lista posicao-na-lista lista &optional (x 1))
	(cond
		(
			(or (null lista) (< numero-da-lista 1) (< posicao-na-lista 1) (null (get-arco-na-posicao numero-da-lista posicao-na-lista lista)))
			nil
		)
		(
			(= numero-da-lista 1)
			(cons (substituir posicao-na-lista (car lista) x) (cdr lista))
		)
		(T
			(cons (car lista) (arco-na-posicao (- numero-da-lista 1) posicao-na-lista (cdr lista) x))
		)
	)
)

(defun arco-horizontal (numero-da-lista posicao-na-lista tabuleiro &optional (x 1))
	(cond
		(
			(or (null tabuleiro) (< numero-da-lista 1) (< posicao-na-lista 1) 
				(null (get-arco-na-posicao numero-da-lista posicao-na-lista (get-arcos-horizontais tabuleiro)))
				(/= (get-arco-na-posicao numero-da-lista posicao-na-lista (get-arcos-horizontais tabuleiro)) 0)
			)
			nil
		)
		(T
			(list
				(arco-na-posicao numero-da-lista posicao-na-lista (get-arcos-horizontais tabuleiro) x)	  
				(get-arcos-verticais tabuleiro)
			)
		)
	)
)

(defun arco-vertical (posicao-na-lista numero-da-lista tabuleiro &optional (x 1))
	(cond
		(
			(or (null tabuleiro) (< numero-da-lista 1) (< posicao-na-lista 1) 
				(null (get-arco-na-posicao numero-da-lista posicao-na-lista (get-arcos-verticais tabuleiro)))
				(/= (get-arco-na-posicao numero-da-lista posicao-na-lista (get-arcos-verticais tabuleiro)) 0)
			)
			nil
		)
		(T
			(list
				(get-arcos-horizontais tabuleiro)
				(arco-na-posicao numero-da-lista posicao-na-lista (get-arcos-verticais tabuleiro) x)	  
			)
		)
	)
)

(defun count-boxes (horizontal-arcs vertical-arcs row col)
  "Count the total number of closed boxes in a dots and boxes game.
   HORIZONTAL-ARCS is a list of lists representing the horizontal arcs, with 1 indicating
   that an arc is drawn and 0 indicating that it is not.
   VERTICAL-ARCS is a list of lists representing the vertical arcs, with 1 indicating
   that an arc is drawn and 0 indicating that it is not.
   ROW and COL are the current row and column being checked."
   	(cond 
		(
			(= row (list-length horizontal-arcs))
         	0
		) ; Base case: We have reached the end of the matrix, so there are no more boxes to count
        (
			(and 
				(= 1 (get-arco-na-posicao row col horizontal-arcs))
              	(= 1 (get-arco-na-posicao col row vertical-arcs))
				(= 1 (get-arco-na-posicao (1+ row) col horizontal-arcs))
				(= 1 (get-arco-na-posicao (1+ col) row vertical-arcs))
			)
         	(+ 1 
				(if 
					(< col (list-length (car horizontal-arcs)))
                  	(count-boxes horizontal-arcs vertical-arcs row (1+ col)) ; Move to the next column
                  	(count-boxes horizontal-arcs vertical-arcs (1+ row) 1) ; Move to the first column of the next row
				)
			)
		) 
        (t
         	(if 
				(< col (list-length (car horizontal-arcs)))
             	(count-boxes horizontal-arcs vertical-arcs row (1+ col)) ; Move to the next column
             	(count-boxes horizontal-arcs vertical-arcs (1+ row) 1) ; Move to the first column of the next row
			)
		)
	)
) 

(defun get-number-of-closed-boxes (board)
	(cond
		(
			(null board)
			nil
		)
		(t
			(count-boxes (get-arcos-horizontais board) (get-arcos-verticais board) 1 1)
		)
	)
)

