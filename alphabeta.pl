dynamic:-
    alpha/2,
    beta/2.

repite.
repite:-
	repite.

carga_archivos:-
    [funcion_heuristica].

comienza_maximizacion(FichaAJugar):-
    generar_estado_actual(State),
    alphabeta(State,4,FichaAJugar).
alphabeta(State,Depth,FichaAJugar):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(7,State,ManoDBW),
    encontrar_fichas_posibles(ValI, ValD, ManoDBW,ListaFichasPosibles),
    poda_alphabeta(State,ListaFichasPosibles,Depth, 1),
    alpha(_,FichaAJugar),
    retractall(alpha),
    retractall(beta).

poda_alphabeta(State,ListaFichasPosibles,Depth, 1):-!.

finish_search(Depth,State):-
    Depth=:=0,!;
    terminal_state(State).
continua(Lista):-
    alpha(Alpha),!,
    beta(Beta),!,
    Beta > Alpha,!;
    length(Lista,Len),
    Len =\= 0. 