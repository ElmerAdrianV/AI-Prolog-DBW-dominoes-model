dynamic:-
    alpha/1,
    beta/1.

carga_archivos_ab:-
    [factorial],
    [funcion_heuristica],
    [domino_ed],
    [auxiliar_heuristico].

%%Player 1 = DBW
%%Player 0 = OP

alphabeta(State,Depth,ValHeur):-
    asserta(alpha(-100000000)),
    asserta(beta(100000000)),
    nth0(5, State, ListaFichasPosibles),
    poda_alphabeta(State,ListaFichasPosibles,Depth,0,ValHeur),
    retractall(alpha),
    retractall(beta),!.

%%caso de profundidad 0
poda_alphabeta(State,_,0,1,ValHeur):-
    funcion_heuristica(State,ValHeur),!.

%% casos de nodo terminal

%% no puede poner DBW
poda_alphabeta(_,ListaFichasPosibles,_,1,ValHeur):-
    length(ListaFichasPosibles,0),
    no_puede_poner_dbw(ValHeur),!.

%% no puede poner OP
poda_alphabeta(_,ListaFichasPosibles,_,0,ValHeur):-
    length(ListaFichasPosibles,0),
    ValHeur is 0,!.

%%empate
poda_alphabeta(State,_,_,1,ValHeur):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(2,State,NumFichasPuntos),
    empate(ValI,ValD,NumFichasPuntos),
    empato_dbw(ValHeur),!.
%%gano dbw 
poda_alphabeta(State,_,_,_,ValHeur):-
    nth0(4,State,NumFichasDBW),
    puede_ganar_dbw(NumFichasDBW),
    gano_dbw(ValHeur),!.

%%perdio dbw
poda_alphabeta(State,_,_,_,ValHeur):-
    nth0(3,State,NumFichasOp),
    perdio_dbw(NumFichasOp),
    perdio_dbw_val_heur(ValHeur),!,.

%%estado maximizador
poda_alphabeta(State,ListaFichasPosibles,Depth,1,ValHeur):-
    NewDepth is Depth - 1, 
    genera_estados_posibles(State, "DBW",ListaFichasPosibles,ListaEstados),!,
    itera_estados_max(ListaEstados, NewDepth, 0),
    alpha(ValHeur).
%%estado minimizador

poda_alphabeta(State,ListaFichasPosibles,Depth,0,ValHeur):-
    NewDepth is Depth - 1, 
    genera_estados_posibles(State, "OP",ListaFichasPosibles, ListaEstados),!,
    itera_estados_min(ListaEstados, NewDepth, 1),
    beta(ValHeur).
%%estado maximizador

itera_estados_max([State|Resto],Depth,Player):-
    alpha(Alpha),
    beta(Beta),
    nth0(5, State, ListaFichasPosibles),
    poda_alphabeta(State,ListaFichasPosibles,Depth,Player,ValHeur),
    MaxAlpha is max(ValHeur, Alpha),
    retractall(alpha),
    asserta(alpha(MaxAlpha)),
    ( Beta =< MaxAlpha ; length(Resto,0) ->
        !;
        itera_estados_max(Resto,Depth,Player)
    ).


%%estado minimizador

itera_estados_min([State|Resto],Depth,Player):-
    alpha(Alpha),
    beta(Beta),
    nth0(5, State, ListaFichasPosibles),
    poda_alphabeta(State,ListaFichasPosibles,Depth,Player,ValHeur),
    MinBeta is min(ValHeur, Beta),
    retractall(beta),
    asserta(beta(MinBeta)),
    ( Alpha =< MinBeta ; length(Resto,0) ->
        !;
        itera_estados_min(Resto,Depth,Player)
    ).

se_puede_poner_en_ambos_lados(ValI,ValD,[Val1,Val2]):-
    (Val1 == ValD, Val2 == ValI),!;
    (Val1 == ValI, Val2 == ValD).

genera_estados_posibles(_,_,[], []):-!.

genera_estados_posibles(State,Jugador,[Ficha|FichasPosibles], [NuevoEstado1,NuevoEstado2|ListaEstados]):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    se_puede_poner_en_ambos_lados(ValI,ValD,Ficha),!, 
    generar_estado_nuevo(Ficha, State, "D", Jugador, NuevoEstado1),
    generar_estado_nuevo(Ficha, State, "I", Jugador, NuevoEstado2),
    genera_estados_posibles(State,Jugador,FichasPosibles, ListaEstados).

genera_estados_posibles(State,Jugador,[[Val1,Val2]|FichasPosibles], [NuevoEstado|ListaEstados]):-
    nth0(1,State,ValD),
    (Val1 == ValD ; Val2 == ValD -> Lado = "D" ; Lado = "I"),!, 
    generar_estado_nuevo([Val1,Val2], State, Lado, Jugador, NuevoEstado),
    genera_estados_posibles(State,Jugador,FichasPosibles, ListaEstados).

write_estados([]):-!.
write_estados([Estado|Resto]):-
    write_estado(Estado),
    write_estados(Resto).
write_estado([ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,ListaFichasPosibles,ListaManoDBW, ListaPozo,NumFichasTab]):-
    write("Estado"),nl,
    write("ValI: "),write(ValI), nl,  
    write("ValD: "),write(ValD), nl, 
    write("NumFichasPuntos: "),write(NumFichasPuntos), nl,  
    write("NumFichasOp: "),write(NumFichasOp), nl,
    write("NumFichasDBW: "),write(NumFichasDBW), nl,  
    write("ListaFichasPosibles: "),write(ListaFichasPosibles), nl,  
    write("ListaManoDBW: "),write(ListaManoDBW), nl,
    write("ListaPozo: "),write(ListaPozo), nl,
    write("NumFichasTab: "),write(NumFichasTab), nl.


%%Player 1 = DBW
%%Player 0 = OP

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
    nth0(7,State,ListaPozo),
    nth0(8,State,NumFichasTab),
   
    (Dir == "D" -> 
    (Val1 == ValD -> 
        NewValD is Val2, NewValI is ValI ; NewValD is Val1, NewValI is ValI) 
    ; (Val1 == ValI ->
        NewValI is Val2, NewValD is ValD; NewValI is Val1, NewValD is ValD)),
    
    (Jugador == "DBW" -> 
        delete(ListaManoDBW, [Val1,Val2], NewListaManoDBW),
        NewListaPozo = ListaPozo,
        encontrar_fichas_posibles(NewValI, NewValD, NewListaPozo, NewListaFichasPosibles),
        NewNumFichasDBW is NumFichasDBW - 1, 
        NewNumFichasOp is NumFichasOp, 
        NewFinalNumFichasPuntos = NumFichasPuntos
        ;
        delete(ListaPozo, [Val1,Val2], NewListaPozo), 
        NewListaManoDBW = ListaManoDBW,
        encontrar_fichas_posibles(NewValI, NewValD, NewListaManoDBW, NewListaFichasPosibles), 
        nth0(Val1,NumFichasPuntos,Val1NumFichas), NewVal1NumFichas is Val1NumFichas - 1, replace(Val1,NumFichasPuntos,NewVal1NumFichas,NewNumFichasPuntos), 
        nth0(Val2,NumFichasPuntos,Val2NumFichas), NewVal2NumFichas is Val2NumFichas - 1, replace(Val2,NewNumFichasPuntos,NewVal2NumFichas,NewFinalNumFichasPuntos),
        NewNumFichasOp is NumFichasOp - 1,
        NewNumFichasDBW is NumFichasDBW),
    
    NewNumFichasTab is NumFichasTab + 1,
    NewState = [
        NewValI, 
        NewValD, 
        NewFinalNumFichasPuntos,
        NewNumFichasOp, 
        NewNumFichasDBW,
        NewListaFichasPosibles,
        NewListaManoDBW,
        NewListaPozo,
        NewNumFichasTab
    ].

%% State i, Ficha o, Lado o
dame_mejor_ficha(State):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(5,State,ListaFichasPosibles), 
    regresar_estado_fichas_posibles(State, ListaFichasPosibles, ValI, ValD, ListaEstadosFichaLado),
    regresar_valor_heuristico_cada_estado(ListaEstadosFichaLado, ListaEstadosFichaLadoAlfaBeta, ListaValores),
    max_list(ListaValores,ValMax),
    regresar_maximo_valor_ficha(ListaEstadosFichaLadoAlfaBeta, ValorMax).

regresar_estado_fichas_posibles(_, [], _, _, []):- !.


regresar_estado_fichas_posibles(State, [[Val1,Val2]|FichasPosibles], ValI, ValD, [[NewState, Lado, [Val1,Val2]]|ListaEstadosFichaLado]):-
    (Val1 == ValD -> Lado = "D" ; (Val2 == ValD -> Lado = "D" ; Lado = "I") ; Lado = "I"), 
    generar_estado_nuevo([Val1,Val2], State, Lado, "DBW", NewState), 
    regresar_estado_fichas_posibles(State, FichasPosibles, ValI,ValD, ListaEstadosFichaLado).

regresar_valor_heuristico_cada_estado([],[], []):-!.

regresar_valor_heuristico_cada_estado([[State, Ficha, Lado]|ListaEstadosFichaLado], [[Valor,Ficha,Lado]|Lista], [Valor|ListaValores]):- 
    alphabeta(State, 5, Valor),
    regresar_valor_heuristico_cada_estado(ListaEstadosFichaLado,Lista, ListaValores).

regresar_maximo_valor_ficha([], _):- !.

regresar_maximo_valor_ficha([[ValorMax,Ficha,Lado]|_], ValorMax):-
    write("Ficha = "),write( Ficha),write( ", lado = "), write(Lado),write( ", Val = "), write(ValorMax),! .
regresar_maximo_valor_ficha([_|ListaEstadosFichaLadoAlfaBeta], ValorMax):-
    regresar_maximo_valor_ficha(ListaEstadosFichaLadoAlfaBeta, ValorMax).