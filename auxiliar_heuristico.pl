:- dynamic
    fichas/1.

carga_archivos:-
    [factorial],
    [funcion_heuristica],
    [domino_ed],
    assertz(fichas([0,0])),
    assertz(fichas([0,1])),
    assertz(fichas([0,2])),
    assertz(fichas([0,3])),
    assertz(fichas([0,4])),
    assertz(fichas([0,5])),
    assertz(fichas([0,6])),
    assertz(fichas([1,1])),
    assertz(fichas([1,2])),
    assertz(fichas([1,3])),
    assertz(fichas([1,4])),
    assertz(fichas([1,5])),
    assertz(fichas([1,6])),
    assertz(fichas([2,2])),
    assertz(fichas([2,3])),
    assertz(fichas([2,4])),
    assertz(fichas([2,5])),
    assertz(fichas([2,6])),
    assertz(fichas([3,3])),
    assertz(fichas([3,4])),
    assertz(fichas([3,5])),
    assertz(fichas([3,6])),
    assertz(fichas([4,4])),
    assertz(fichas([4,5])),
    assertz(fichas([4,6])),
    assertz(fichas([5,5])),
    assertz(fichas([5,6])),
    assertz(fichas([6,6])).

% Predicado para encontrar todas las opciones que tenemos


encontrar_fichas_posibles_dbw(Lista):- 
    encontrar_fichas_posibles_dbw_izq(Lista1),
    encontrar_fichas_posibles_dbw_der(Lista2),
    union(Lista1, Lista2, Lista).

encontrar_fichas_posibles_dbw_izq_aux(X):-
    izquierdo(Izq),
    tengo(X),
    ficha_contiene(Izq, X).

encontrar_fichas_posibles_dbw_izq(Lista):-
    findall(X, encontrar_fichas_posibles_dbw_izq_aux(X), Lista).

encontrar_fichas_posibles_dbw_der_aux(X):-
    derecho(Der),
    tengo(X),
    ficha_contiene(Der, X).

encontrar_fichas_posibles_dbw_der(Lista):-
    findall(X, encontrar_fichas_posibles_dbw_der_aux(X), Lista).

% Predicado para encontrar las opciones que tiene el op
encontrar_fichas_posibles_op_izq_aux(X):-
    izquierdo(Izq),
    fichas(X),
    not(tengo(X)),
    not(jugado(X)),
    ficha_contiene(Izq, X).

encontrar_fichas_posibles_op_izq(Lista):-
   findall(X,encontrar_fichas_posibles_op_izq_aux(X), Lista).

encontrar_fichas_posibles_op_der_aux(X):-
    derecho(Der),
    fichas(X),
    not(tengo(X)),
    not(jugado(X)),
    ficha_contiene(Der, X).

encontrar_fichas_posibles_op_der(Lista):-
    findall(X, encontrar_fichas_posibles_op_der_aux(X), Lista).

encontrar_fichas_posibles_op(Lista):- 
    encontrar_fichas_posibles_op_izq(Lista1),
    encontrar_fichas_posibles_op_der(Lista2),
    union(Lista1, Lista2, Lista).