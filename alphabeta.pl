dynamic:-
    alpha/2,
    beta/2.

repite.
repite:-
	repite.

carga_archivos:-
    [funcion_heuristica],
    [domino_ed],
    [auxiliar_heuristico].

comienza_maximizacion(FichaAJugar):-
    generar_estado_actual(State),
    alphabeta(State,4,FichaAJugar).
alphabeta(State,Depth,FichaAJugar):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(7,State,ManoDBW),
    encontrar_fichas_posibles(ValI, ValD, ManoDBW,ListaFichasPosibles).
    %% hacer una lista que guarde la ficha y el valor heuristico que regresa para cada una


%%Player 1 = DBW
%%Player 0 = OP

%% necesitamos un dada una ficha genera un nuevo estado

% I=Índice, L=Lista, E=Elemento, K=Resultado
replace(I, L, E, K):-
  nth0(I, L, _, R),
  nth0(I, K, E, R).

generar_estado_nuevo([Val1,Val2], State, Dir, Jugador, NewState):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(2,State,NumFichasPuntos),
    nth0(3,State,NumFichasOp),
    nth0(4,State,NumFichasDBW),
    nth0(6,State,ListaManoDBW),
    %%(length(ListaFichasPosibles) == 0 -> !),


    (Dir == "D" -> 
        (Val1 == ValD -> 
            NewValD is Val2, NewValI is ValI ; NewValD is Val1, NewValI is ValI), 
        (Jugador \== "DBW" ->
            nth0(NewValD,NumFichasPuntos,ValDNumFichas), NewValDNumFichas is ValDNumFichas - 1, replace(ValD,NumFichasPuntos,NewValDNumFichas,NewNumFichasPuntos))
    ; (Val1 == ValI ->
            NewValI is Val2, NewValD is ValD; NewValI is Val1, NewValD is ValD),  
        (Jugador \== "DBW" ->
            nth0(NewValI,NumFichasPuntos,ValINumFichas), NewValINumFichas is ValINumFichas - 1, replace(ValI,NumFichasPuntos,NewValINumFichas,NewNumFichasPuntos))),
    
    (Jugador == "DBW" -> 
        delete(ListaManoDBW, [Val1,Val2], NewListaManoDBW),
        encontrar_fichas_posibles(NewValI, NewValD, NewListaManoDBW, NewListaFichasPosibles), 
        NewNumFichasDBW is NumFichasDBW - 1
        ; 
        NewNumFichasOp is NumFichasOp - 1),
    
    NewState = [
        NewValI, 
        NewValD, 
        NewNumFichasPuntos,
        NewNumFichasOp, 
        NewNumFichasDBW,
        NewListaFichasPosibles,
        NewListaManoDBW
    ].

poda_alphabeta(State,ListaFichasPosibles,Depth):-
    NewDepth is Depth - 1,
    poda_alphabeta(State,ListaFichasPosibles,NewDepth, 0).
poda_alphabeta(State,ListaFichasPosibles,Depth, 0):-
    poda_alphabeta(State,ListaFichasPosibles,Depth, 1).

finish_search(Depth,State):-
    Depth=:=0,!;
    terminal_state(State).
continua(Lista):-
    alpha(Alpha),!,
    beta(Beta),!,
    Beta > Alpha,!;
    length(Lista,Len),
    Len =\= 0. 