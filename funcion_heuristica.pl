carga_archivos:-
    [factorial],
    [domino_ed].

funcion_heuristica(State,Ficha,ValHeur):-
    nth0(0,State,ValD),
    nth0(1,State,ValI),
    nth0(2,State,NumFichasPuntos),
    nth0(3,State,NumFichasOp),
    nth0(4,State,NumFichasDBW),
    nth0(5,State,ListaFichasPosibles),
    nth0(6,State,ListaManoDBW),
    ( perdio_dbw(NumFichasOp) ->
        perdio_dbw_val_heur(ValHeur);
        ( empate(ValI,ValD,NumFichasPuntos) ->
            empato_dbw(ValHeur);
            ( puede_poner_dbw(ValI,ValD,Ficha) ->
                ( puede_ganar_dbw(NumFichasDBW) ->
                    gano_dbw(ValHeur);
                    calcula_val_heur_mejor_mov(Ficha,ValHeur)
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

calcula_val_heur_mejor_mov(ValI,ValD,NumFichasPuntos,[X,Y],P):-
    %%Calculando pongo en lado derecho
    calcula(ValI,Y,PXI),
    calcula(ValI,X,PYI),
    %%Calculando pongo en lado izquierdo
    calcula(Y,ValD,PDX),
    calcula(X,ValD,PDY),
    PD is min(PDX,PDY),
    PI is min(PXI,PYI ),
    P is min(PD,PI).

calcula(ValI,ValD,ValHeur):-
    empate(ValI,ValD), empato_dbw(ValHeur),!;
    calcula_probabilidad(ValI,PI),
    calcula_probabilidad(ValI,PD),
    ValHeur is 50*(PI+PD).

calcula_probabilidad(Val,P):-
    cuenta(Val,Num_FV),
    num_fichas_op(Num_FOP),
    num_fichas_dbw(Num_FDBW),
    max(Num_FV,Num_FOP,MaxDenI),
    calcula_num(Val,MaxDenI,0, Nums),
    sum(Nums, SumNum),
    Num_F is 28 - Num_FOP - Num_FDBW,
    combinacion(Num_F, Num_FOP, Den),
    P is SumNum / Den.

calcula_num(_,Max,Max+1, []):-!.

calcula_num(Val,Max,I, [X|Lista]):-
    calcula_num(Val,I, X),
    NuevoI is I,
    calcula_num(Val,Max,NuevoI, Lista).

calcula_num(Val, I, X):-
    cuenta(Val,Num_FV),
    num_fichas_op(Num_FOP),
    num_fichas_dbw(Num_FDBW),
    combinaciones(Num_FV,I,Comb1),
    Num_F is 28 - Num_FOP - Num_FDBW,
    ResManoJ2 is Num_FOP - I,  
    combinaciones(Num_F,ResManoJ2,Comb2),
    X is Comb1*Comb2.
