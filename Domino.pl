:- dynamic
    tengo/1, %Nos dice si tenemos cierta ficha
    jugado/1, %Nos dice si una ficha está en el tablero
    oponente_tiene/1,
    pozo/1, %Nos dice si una ficha está en el pozo (no vista)
    op_no_tiene/1, %Nos indica si un oponente no tiene un número
    derecho/1, %Nos indica el número abierto en el extremo derecho
    izquierdo/1. %Nos indica el número abierto en el extremo izquierdo


/*
Método para "limpiar" el tablero y empezar un nuevo juego
  - Pone todas las fichas en el pozo (pozo)
  - Vacía la mano de los jugadores (tengo)
  - Vacía el tablero (jugado)
  - Limpia conocimientos sobre lo que no tiene el contrincante (op_no_tiene)
  - Reinicia las cuentas (cuenta)
  - Limpia los extremos
*/
empieza_juego():-
retractall(pozo(_)),
retractall(tengo(_)),
retractall(jugado(_)),
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
assertz(cuenta([1,7])),
assertz(cuenta([2,7])),
assertz(cuenta([3,7])),
assertz(cuenta([4,7])),
assertz(cuenta([5,7])),
assertz(cuenta([6,7])).

assertz(prob([1,0.4])),
assertz(cuenta([2,7])),
assertz(cuenta([3,7])),
assertz(cuenta([4,7])),
assertz(cuenta([5,7])),
assertz(cuenta([6,7])).

/*Considera fichas jugadas,*/


actualiza_probabilidad(Valor):-
  !.


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
  actualiza_cuentas(Val1),
  Val1 \== Val2,
  actualiza_cuentas(Val2).

/*
Método para registrar que se roba una ficha
Actualiza la mano, y las cuentas de las fichas según
la ficha que tomamos
*/
%Se debe registrar la ficha como [Menor|Mayor]
tomo_ficha(Ficha):-
  assertz(tengo(FichaOrd)),
  retract(pozo(FichaOrd)),
  actualiza_cuentas(FichaOrd).


/*
Método para regsitrar la mano inicial de 7 fichas que tomamos
Actualizando la mano, el pozo y las cuentas
*/
mano_inicial([]):-!.

mano_inicial([Mano|RestoMano]) :-
  tomo_ficha(FichaOrd),
  mano_inicial(RestoMano).




juego([Val1,Val2|_],"D") :-
  retract(derecho(_)),
  assertz(derecho(Val2)),
  retract(tengo([Val1,Val2])),
  assertz(jugado([Val1,Val2])).

juego([Val1,Val2|_],"I") :-
  retract(izquierdo(_)),
  assertz(izquierdo(Val2)),
  retract(tengo([Val1,Val2])),
  assertz(jugado([Val1,Val2])).

juega([Val1,Val2|_],"D") :-
  retract(derecho(_)),
  assertz(derecho(Val2)),
  assertz(jugado([Val1,Val2])),
  retract(pozo([Val1,Val2])),
  actualiza_cuentas([Val1,Val2]).

juega([Val1,Val2|_],"I") :-
  retract(izquierdo(_)),
  assertz(izquierdo(Val2)),
  assertz(jugado([Val1,Val2])),
  retract(pozo([Val1,Val2])),
  actualiza_cuentas([Val1,Val2]).




imprime_mano(X) :-
  tengo(X),write(X),nl,fail.
imprime_tablero(X) :-
  jugado(X),write(X),nl,fail.

ficha_contiene(Valor,[Valor,_|_]):- !.
ficha_contiene(Valor,[_,Valor|_]):- !.

movimientos_disponibles(X):-
  izquierdo(IZQ),
  tengo(X),
  ficha_contiene(IZQ,X).

movimientos_disponibles(X):-
  derecho(DER),
  tengo(X),
  ficha_contiene(DER,X).

/*
Evalua, dado las fichas en mano, en el pozo, 
y lo que sabemos de la mano del jugador, el valor
heurístico del estado. 
*/
evalua_estado():-
!.
