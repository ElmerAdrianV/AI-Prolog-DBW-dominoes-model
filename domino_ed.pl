:- dynamic                                                                                                 
	mano_dbw/1, %Nos dice si tenemos cierta ficha                                                             
	tablero/1, %Nos dice si una ficha está en el tablero 
	oponente_tiene/1,                                                                                     
	pozo/1, %Nos dice si una ficha está en el pozo (no vista)                                              
	op_no_tiene/1, %Nos indica si un oponente no tiene un número                                           
	derecho/1, %Nos indica el número abierto en el extremo derecho                                         
	izquierdo/1, %Nos indica el número abierto en el extremo izquierdo
  num_fichas_dbw/1, %Numero de fichas que tenemos 
  num_fichas_op/1. %Numero de fichas que tiene el oponente

empieza_juego:-
  retractall(pozo(_)),
  retractall(mano_dbw(_)),
  retractall(tablero(_)),
  retractall(oponente_tiene(_)),
  retractall(op_no_tiene(_)),
  retractall(cuenta(_)),
  retractall(derecho(_)),
  retractall(izquierdo(_)),
  write("Todos los predicados borrados"),

  %Ponemos fichas en el pozo
  assertz(pozo([0,0])),
  assertz(pozo([0,1])),
  assertz(pozo([0,2])),
  assertz(pozo([0,3])),
  assertz(pozo([0,4])),
  assertz(pozo([0,5])),
  assertz(pozo([0,6])),
  assertz(pozo([1,1])),
  assertz(pozo([1,2])),
  assertz(pozo([1,3])),
  assertz(pozo([1,4])),
  assertz(pozo([1,5])),
  assertz(pozo([1,6])),
  assertz(pozo([2,2])),
  assertz(pozo([2,3])),
  assertz(pozo([2,4])),
  assertz(pozo([2,5])),
  assertz(pozo([2,6])),
  assertz(pozo([3,3])),
  assertz(pozo([3,4])),
  assertz(pozo([3,5])),
  assertz(pozo([3,6])),
  assertz(pozo([4,4])),
  assertz(pozo([4,5])),
  assertz(pozo([4,6])),
  assertz(pozo([5,5])),
  assertz(pozo([5,6])),
  assertz(pozo([6,6])),

  % Cuántas fichas de un número quedan en el pozo/mano del otro?
  assertz(cuenta([0,7])),
  assertz(cuenta([1,7])),
  assertz(cuenta([2,7])),
  assertz(cuenta([3,7])),
  assertz(cuenta([4,7])),
  assertz(cuenta([5,7])),
  assertz(cuenta([6,7])),

  assertz(num_fichas_op(7)),
  assertz(num_fichas_dbw(0)).

/*
Métodos que actualizan las cuentas de fichas
cuando se juega o se toma una ficha
*/
%Invariante al orden
%Auxiliar para actualizar valores
actualiza_cuentas(Val):-
  cuenta([Val,X]),
  NewX is X-1,
  retract(cuenta([Val,_])),
  assertz(cuenta([Val,NewX])),
  !.
%Recibe una ficha y actualiza su cuenta
actualiza_cuentas([Val1,Val2|_]) :-
  ( Val1 \== Val2 ->
  actualiza_cuentas(Val1),
  actualiza_cuentas(Val2) ; 
  actualiza_cuentas(Val1) ).

ordenar([Val1,Val2|_],[Val2,Val1]):-                                                                     
    Val2 < Val1,!.                                                                                                                                                                                              
ordenar([Val1,Val2|_], [Val1,Val2]):-                                                                    
    !.  

/*
Método para registrar que se roba una ficha
Actualiza la mano, y las cuentas de las fichas según
la ficha que tomamos
*/
% Se debe registrar la ficha como [Menor|Mayor]
tomo_ficha(Mano):-
  ordenar(Mano,FichaOrd),
  assertz(mano_dbw(FichaOrd)),
  retract(pozo(FichaOrd)),
  actualiza_cuentas(FichaOrd),

  retract(num_fichas_dbw(Num)), 
  Newnum is Num+1, 
  assertz(num_fichas_dbw(Newnum)).

toma_ficha_op:- 
  retract(num_fichas_op(Num)),
  Newnum is Num+1, 
  assertz(num_fichas_op(Newnum)).

pone_ficha_dbw:- 
  retract(num_fichas_dbw(Num)),
  Newnum is Num-1, 
  assertz(num_fichas_dbw(Newnum)).

pone_ficha_op:-
  retract(num_fichas_op(Num)),
  Newnum is Num-1, 
  assertz(num_fichas_op(Newnum)).

/*
Método para regsitrar la mano inicial de 7 fichas que tomamos
Actualizando la mano, el pozo y las cuentas
*/
mano_inicial([]):-!.

mano_inicial([Mano|RestoMano]) :-
  tomo_ficha(Mano),
  mano_inicial(RestoMano).

pon_primera_ficha(Ficha, Jugador) :-
  ordenar(Ficha, [Val1,Val2]), 
  assertz(derecho(Val2)),
  assertz(izquierdo(Val1)),
  (Jugador == "DBW" -> 
  retract(mano_dbw([Val1,Val2])),
  pone_ficha_dbw;
  retract(pozo([Val1,Val2])), 
  actualiza_cuentas([Val1,Val2]), 
  pone_ficha_op),
  assertz(tablero([Val1,Val2])).

juega_dbw(Ficha,"D") :-
  ordenar(Ficha, [Val1, Val2]),
  derecho(ValD),
  retract(derecho(_)),
  (ValD == Val2 ->
  assertz(derecho(Val1)) ; 
  assertz(derecho(Val2))),

  retract(mano_dbw([Val1,Val2])),
  assertz(tablero([Val1,Val2])), 
  
  pone_ficha_dbw.

juega_dbw(Ficha,"I") :-
  ordenar(Ficha, [Val1, Val2]),
  izquierdo(ValI),
  retract(izquierdo(_)),
  (ValI == Val2 ->  
  assertz(izquierdo(Val1)) ; 
  assertz(izquierdo(Val2)) ), 

  retract(mano_dbw([Val1,Val2])),
  assertz(tablero([Val1,Val2])), 

  pone_ficha_dbw.

juega_op(Ficha,"D") :-
  ordenar(Ficha, [Val1, Val2]),
  derecho(ValD),
  retract(derecho(_)),
  (ValD == Val2 ->
  assertz(derecho(Val1)) ; 
  assertz(derecho(Val2))),

  assertz(tablero([Val1,Val2])),
  retract(pozo([Val1,Val2])),
  actualiza_cuentas([Val1,Val2]), 
  
  pone_ficha_op.

juega_op(Ficha,"I") :-
  ordenar(Ficha, [Val1, Val2]),
  izquierdo(ValI),
  retract(izquierdo(_)),
  (ValI == Val2 ->
  assertz(izquierdo(Val1)) ; 
  assertz(izquierdo(Val2))),

  assertz(tablero([Val1,Val2])),
  retract(pozo([Val1,Val2])),
  actualiza_cuentas([Val1,Val2]),
  
  pone_ficha_op.


imprime_mano(X) :-
  mano_dbw(X),write(X),nl,fail.
imprime_tablero(X) :-
  tablero(X),write(X),nl,fail.

ficha_contiene(Valor,[Valor,_|_]):- !.
ficha_contiene(Valor,[_,Valor|_]):- !.

movimientos_disponibles(X):-
  izquierdo(IZQ),
  mano_dbw(X),
  ficha_contiene(IZQ,X).

movimientos_disponibles(X):-
  derecho(DER),
  mano_dbw(X),
  ficha_contiene(DER,X).

/*
Evalua, dado las fichas en mano, en el pozo, 
y lo que sabemos de la mano del jugador, el valor
heurístico del estado. 
*/
evalua_estado:-
!.
