:- dynamic
    fichas/1.

carga_archivos:-
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
    mano_dbw(X),
    ficha_contiene(Izq, X).

encontrar_fichas_posibles_dbw_izq(Lista):-
    findall(X, encontrar_fichas_posibles_dbw_izq_aux(X), Lista).

encontrar_fichas_posibles_dbw_der_aux(X):-
    derecho(Der),
    mano_dbw(X),
    ficha_contiene(Der, X).

encontrar_fichas_posibles_dbw_der(Lista):-
    findall(X, encontrar_fichas_posibles_dbw_der_aux(X), Lista).

% Predicado para encontrar las opciones que tiene el op
encontrar_fichas_posibles_op_izq_aux(X):-
    izquierdo(Izq),
    fichas(X),
    not(mano_dbw(X)),
    not(tablero(X)),
    ficha_contiene(Izq, X).

encontrar_fichas_posibles_op_izq(Lista):-
   findall(X,encontrar_fichas_posibles_op_izq_aux(X), Lista).

encontrar_fichas_posibles_op_der_aux(X):-
    derecho(Der),
    fichas(X),
    not(mano_dbw(X)),
    not(tablero(X)),
    ficha_contiene(Der, X).

encontrar_fichas_posibles_op_der(Lista):-
    findall(X, encontrar_fichas_posibles_op_der_aux(X), Lista).

encontrar_fichas_posibles_op(Lista):- 
    encontrar_fichas_posibles_op_izq(Lista1),
    encontrar_fichas_posibles_op_der(Lista2),
    union(Lista1, Lista2, Lista).

generar_estado_actual(State):-
    derecho(ValD),
    izquierdo(ValI),
    cuentaFichasPuntos(NumFichasPuntos),
    num_fichas_op(NumFichasOp),
    num_fichas_dbw(NumFichasDBW),
    encontrar_fichas_posibles_dbw(ListaFichasPosibles),
    generar_mano_dbw(ListaManoDBW),
    State = [
        ValD,
        ValI,
        NumFichasPuntos,
        NumFichasOp,
        NumFichasDBW,
        ListaFichasPosibles,
        ListaManoDBW
    ].

%%Necesitamos un replace nth element

generar_mano_dbw(ListaManoDBW):-
    findall(X, mano_dbw(X), ListaManoDBW).

cuentaFichasPuntos(Lista):-
    cuenta([0,Val0]),
    cuenta([1,Val1]),
    cuenta([2,Val2]),
    cuenta([3,Val3]),
    cuenta([4,Val4]),
    cuenta([5,Val5]),
    cuenta([6,Val6]),
    Lista = [Val0,Val1,Val2,Val3,Val4,Val5,Val6].