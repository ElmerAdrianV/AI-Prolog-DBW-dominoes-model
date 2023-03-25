carga_archivos:-
    [factorial],
    [auxiliar_heuristico].

funcion_heuristica(State,ValHeur):-
    nth0(0,State,ValI),
    nth0(1,State,ValD),
    nth0(2,State,NumFichasPuntos),
    nth0(3,State,NumFichasOp),
    nth0(4,State,NumFichasDBW),
    nth0(7,State,NumFichasTab),
    ( perdio_dbw(NumFichasOp) ->
        perdio_dbw_val_heur(ValHeur);
        ( empate(ValI,ValD,NumFichasPuntos) ->
            empato_dbw(ValHeur);
                ( puede_ganar_dbw(NumFichasDBW) ->
                    gano_dbw(ValHeur);
                    calcula_val_heur_mejor_mov(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,ValHeur)
                )
        )
    ).

perdio_dbw(NumFichasOp):-
    NumFichasOp=:=0.

perdio_dbw_val_heur(ValHeur):-
    ValHeur is 100000.

empate(ValI,ValD,NumFichasPuntos):-
    nth0(ValD,NumFichasPuntos,0),
    nth0(ValI,NumFichasPuntos,0).

empato_dbw(ValHeur):-
    ValHeur is 10000.

no_puede_poner_dbw(ValHeur):-
    ValHeur is 1000.

puede_ganar_dbw(NumFichasDBW):-
    NumFichasDBW=:=0.

ganar_dbw(ValHeur):-
    ValHeur is 0.

calcula_val_heur_mejor_mov(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,P):-
    %%Calculando pongo en lado derecho
    calcula(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,P).

calcula(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,ValHeur):-
    calcula_probabilidad(ValI,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,PI),
    calcula_probabilidad(ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,PD),
    ValHeur is max(PI,PD).

calcula_probabilidad(Val,NumFichasPuntos,NumFichasOp,NumFichasDBW,NumFichasTab,P):-
    nth0(Val,NumFichasPuntos,NumFichaVal),
    MinNumI is min(NumFichaVal,NumFichasOp),
    NumFichas is 28 - NumFichasTab - NumFichasDBW,
    ResNumFichas is NumFichas - NumFichaVal,
    calcula_nums(NumFichaVal,NumFichasOp,ResNumFichas,MinNumI,1, Nums),
    sumlist(Nums, SumNum),
    combinaciones(NumFichas, NumFichasOp, Den),
    P is SumNum / Den.



calcula_nums(NumFichaVal,NumFichasOp,ResNumFichas,Min,I, [X|Lista]):-
    (Min + 1 =:= I ->
        X is 0,
        Lista = [];
        calcula_num(NumFichaVal,NumFichasOp,ResNumFichas,I, X),
        NuevoI is I+1,
        calcula_nums(NumFichaVal,NumFichasOp,ResNumFichas,Min,NuevoI, Lista)
    ).
    

calcula_num(NumFichaVal,NumFichasOp,ResNumFichas, I, X):-
    combinaciones(NumFichaVal,I,Comb1),
    ResManoJ2 is NumFichasOp - I,  
    combinaciones(ResNumFichas,ResManoJ2,Comb2),
    X is Comb1*Comb2.
