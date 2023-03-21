carga_archivos:-
    [factorial],
    [funcion_heuristica],
    [domino_ed].

% Predicado para encontrar todas las opciones que tenemos
encontrar_fichas_posibles_dbw_izq(Lista, [X|Lista]):-
    izquierdo(Izq),
    tengo(X),
    ficha_contiene(Izq, X).

encontrar_fichas_posibles_dbw_der(Lista, [X|Lista]):-
    derechoo(Der),
    tengo(X),
    ficha_contiene(Der, X).

% Predicado para encontrar las opciones que tiene el op
encontrar_fichas_posibles_op_izq(Lista, [X|Lista]):-
    izquierdo(Izq),
    not(tengo(X)),
    not(jugado(X)),
    ficha_contiene(Izq, X).
% 