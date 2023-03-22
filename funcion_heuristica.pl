carga_archivos:-
    [factorial],
    [domino_ed].

funcion_heuristica(State,Ficha,ValHeur):-
    nth0(0,State,ValD),
    nth0(1,State,ValI),
    nth0(2,State,NumFichasPuntos),
    nth0(3,State,NumFichasOp),
    nth0(4,State,NumFichasDBW),
    ( perdio_dbw(NumFichasOp) ->
        perdio_dbw_val_heur(ValHeur);
        ( empate(ValI,ValD,NumFichasPuntos) ->
            empato_dbw(ValHeur);
            ( puede_poner_dbw(ValI,ValD,Ficha) ->
                ( puede_ganar_dbw(NumFichasDBW) ->
                    gano_dbw(ValHeur);
                    calcula_val_heur_mejor_mov(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,Ficha,ValHeur)
                )
                ;
                no_puede_poner_dbw(ValHeur)
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

puede_poner_dbw(ValI,ValD,[X,Y]):-
   X=:=ValI,!;
   X=:=ValD,!;
   Y=:=ValI,!;
   Y=:=ValD,!.

no_puede_poner_dbw(ValHeur):-
    ValHeur is 1000.

puede_ganar_dbw(NumFichasDBW):-
    NumFichasDBW=:=1.

ganar_dbw(ValHeur):-
    ValHeur is 0.

calcula_val_heur_mejor_mov(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,[X,Y],P):-
    %%Calculando pongo en lado derecho
    calcula(ValI,Y,NumFichasPuntos,NumFichasOp,NumFichasDBW,PXI),
    calcula(ValI,X,NumFichasPuntos,NumFichasOp,NumFichasDBW,PYI),
    %%Calculando pongo en lado izquierdo
    calcula(Y,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,PDX),
    calcula(X,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,PDY),
    PD is min(PDX,PDY),
    PI is min(PXI,PYI ),
    P is min(PD,PI).

calcula(ValI,ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,ValHeur):-
    empate(ValI,ValD), empato_dbw(ValHeur),!;
    calcula_probabilidad(ValI,NumFichasPuntos,NumFichasOp,NumFichasDBW,PI),
    calcula_probabilidad(ValD,NumFichasPuntos,NumFichasOp,NumFichasDBW,PD),
    ValHeur is 50*(PI+PD).

calcula_probabilidad(Val,NumFichasPuntos,NumFichasOp,NumFichasDBW,P):-
    nth0(Val,NumFichasPuntos,NumFichaVal),
    max(NumFichaVal,NumFichasOp,MaxNumI),
    calcula_num(NumFichaVal,NumFichasOp,NumFichasDBW,MaxNumI,0, Nums),
    sum(Nums, SumNum),
    NumFichas is 28 - NumFichasOp - NumFichasDBW,
    combinacion(NumFichas, NumFichasOp, Den),
    P is SumNum / Den.

calcula_nums(_,_,_,Max,Max+1, []):-!.

calcula_nums(NumFichaVal,NumFichasOp,NumFichasDBW,Max,I, [X|Lista]):-
    calcula_num(NumFichaVal,NumFichasOp,NumFichasDBW,I, X),
    NuevoI is I,
    calcula_nums(NumFichaVal,NumFichasOp,NumFichasDBW,Max,NuevoI, Lista).

calcula_num(NumFichaVal,NumFichasOp,NumFichasDBW, I, X):-
    combinaciones(NumFichaVal,I,Comb1),
    NumFichas is 28 - NumFichasOp - NumFichasDBW,
    ResManoJ2 is NumFichasOp - I,  
    combinaciones(NumFichas,ResManoJ2,Comb2),
    X is Comb1*Comb2.
