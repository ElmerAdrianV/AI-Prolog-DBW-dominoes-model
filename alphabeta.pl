dynamic:-
    alpha/1,
    beta/1.

repite.
repite:-
	repite.

carga_archivos_ab:-
    [factorial],
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

%%caso de profundidad 0
poda_alphabeta(State,0,1,ValHeur):-
    funcion_heuristica(State,ValHeur),!.

%% casos de nodo terminal

%% no puede poner DBW
poda_alphabeta(State,Depth,1,ValHeur):-
    nth(5, State, ListaFichasPosibles),
    length(ListaFichasPosibles,0),
    no_puede_poner_dbw(ValHeur),!.

%% no puede poner OP
poda_alphabeta(State,Depth,0,ValHeur):-
    nth(5, State, ListaFichasPosibles),
    length(ListaFichasPosibles,0),
    ValHeur is 0,!.

%%empate
poda_alphabeta(State,Depth,1,ValHeur):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(2,State,NumFichasPuntos),
    empate(ValI,ValD,NumFichasPuntos),
    empato_dbw(ValHeur),!.
%%gano dbw 
poda_alphabeta(State,Depth,_,ValHeur):-
    nth0(4,State,NumFichasDBW),
    puede_ganar_dbw(NumFichasDBW),
    gano_dbw(ValHeur),!.

%%perdio dbw
poda_alphabeta(State,Depth,_,ValHeur):-
    nth0(3,State,NumFichasOp),
    perdio_dbw(NumFichasOp),
    perdio_dbw_val_heur(ValHeur),!.

%%estado maximizador
poda_alphabeta(State,Depth,1,ValHeur):-
    NewDepth is Depth - 1, 
    genera_todos_estados_posibles(State,"DBW",ListaEstados),
    itera_estados_max(ListaEstados, NewDepth, 0),
    alpha(ValHeur).

itera_estados_max([State|Resto],Depth,Player):-
    alpha(Alpha),
    beta(Beta),
    poda_alphabeta(State,Depth,Player,ValHeur),
    MaxAlpha is max(ValHeur, Alpha),
    retractall(alpha),
    asserta(alpha(MaxAlpha)),
    ( Beta =< MaxAlpha ; length(Resto,0) ->
        true;
        itera_sobre_esto(Resto,Depth,Player)
    ).


%%estado minimizador
poda_alphabeta(State,ListaFichasPosibles,Depth,0,ValHeur):-
    NewDepth is Depth - 1, 
    genera_todos_estados_posibles(State, "OP", ListaEstados),
    itera_estados_min(ListaEstados, NewDepth, 1),
    beta(ValHeur).

itera_estados_min([State|Resto],Depth,Player):-
    alpha(Alpha),
    beta(Beta),
    poda_alphabeta(State,Depth,Player,ValHeur),
    MinBeta is min(ValHeur, Beta),
    retractall(beta),
    asserta(beta(MinBeta)),
    ( Alpha =< MinBeta ; length(Resto,0) ->
        true;
        itera_estados_min(Resto,Depth,Player)
    ).

genera_estados_posibles(State,Player,[Ficha|ListaFichasPosibles], [NewState| Resto]):-
    generar_estado_nuevo(State,Ficha,"D",Jugador,Lado).

genera_estados_posibles([], _, _, ListaAux, ListaAux):-

%%Player 1 = DBW
%%Player 0 = OP

genera_estados_posibles(State,Jugador,[[Val1,Val2]|FichasPosibles], ListaEstados):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    (Val1 == ValD ; Val2 == ValD -> Lado is "D" ; Lado is "I"), 
    generar_estado_nuevo([Val1,Val2], State, Lado, Jugador, NuevoEstado), 
    append(NuevoEstado, ListaEstados, NewListaEstados ),
    pasar_por_fichas(State, Jugador,FichasPosibles, NewListaEstados).

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


finish_search(Depth,State):-
    Depth=:=0,!;
    terminal_state(State).
continua(Lista):-
    alpha(Alpha),!,
    beta(Beta),!,
    Beta > Alpha,!;
    length(Lista,Len),
    Len =\= 0. 