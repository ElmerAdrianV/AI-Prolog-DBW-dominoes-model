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
    %nth0(5,State,ListaFichasPosibles),
    nth0(6,State,ListaManoDBW),
    %%(length(ListaFichasPosibles) == 0 -> !),


    (Dir == "D" -> 
    (Val1 == ValD -> 
        NewValD is Val2, NewValI is ValI ; NewValD is Val1, NewValI is ValI) 
    ; (Val1 == ValI ->
        NewValI is Val2, NewValD is ValD; NewValI is Val1, NewValD is ValD)),
    


    (Jugador == "DBW" -> 
        delete(ListaManoDBW, [Val1,Val2], NewListaManoDBW),
        encontrar_fichas_posibles(NewValI, NewValD, NewListaManoDBW, NewListaFichasPosibles), 
        NewNumFichasDBW is NumFichasDBW - 1, 
        NewNumFichasOp is NumFichasOp, 
        NewNumFichasPuntos = NumFichasPuntos
        ; 
        nth0(Val1,NumFichasPuntos,Val1NumFichas), NewVal1NumFichas is Val1NumFichas - 1, replace(Val1,NumFichasPuntos,NewVal1NumFichas,NewNumFichasPuntos), 
        nth0(Val2,NumFichasPuntos,Val2NumFichas), NewVal2NumFichas is Val2NumFichas - 1, replace(Val2,NumFichasPuntos,NewVal2NumFichas,NewNumFichasPuntos),
        NewNumFichasOp is NumFichasOp - 1),
    
    NewState = [
        NewValI, 
        NewValD, 
        NewNumFichasPuntos,
        NewNumFichasOp, 
        NewNumFichasDBW,
        NewListaFichasPosibles,
        NewListaManoDBW
    ],
    write(NewValI), nl,  write(NewValD), nl, write(NewNumFichasPuntos), nl,  write(NewNumFichasOp), nl,
    write(NewNumFichasDBW), nl,  write(NewListaFichasPosibles), nl,  write(NewListaManoDBW), nl.

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