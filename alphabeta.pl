dynamic:-
    alpha/1,
    iteracion/1,
    beta/1.

repite.
repite:-
	repite.

carga_archivos:-
    [funcion_heuristica].

alphabeta(State,Ficha,Depth,Alpha,Beta, MaxiPlayer, ValHeur):-
    (   finish_search(Depth,State) ->
            funcion_heuristica(State,Ficha, ValHeur);
        (   MaxiPlayer =:=1 ->
            ( continua(ListaManoDBW) -> 
                ;
                
            )
            ;
        )
    )
finish_search(Depth,State):-
    Depth=:=0,!;
    terminal_state(State).
continua(Lista):-
    alpha(Alpha),
    beta(Beta),
    Beta > Alpha,!;
    length(Lista,Len),
    Len =\= 0. 