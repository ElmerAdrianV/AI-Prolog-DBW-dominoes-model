carga_archivos:-
    [factorial],
    [domino].
funcion_heuristica(Ficha,ValHeur):-
    ( perdio_dbw ->
        perdio_dbw(ValHeur);
        ( empate ->
            empato_dbw(ValHeur);
            ( puede_poner_dbw(Ficha) ->
                ( puede_ganar_dbw ->
                    gano_dbw(ValHeur);
                    calcula_val_heur_mejor_mov(Ficha,ValHeur)
                )
                ;
                no_puede_poner_dbw(ValHeur)
            )
        )
    ).

calcula_val_heur_mejor_mov([X,Y],P):-
    %%Calculando pongo en lado derecho
    calcula(ValI,Y,PXI),
    calcula(ValI,X,PYI),
    %%Calculando pongo en lado izquierdo
    calcula(Y,ValD,PDX),
    calcula(X,ValD,PDY),
    min(PDX,PDI,PD),
    min(PXI,PYI,PI),
    min(PD,PI,P).

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
    calcula_num(Max,I, X),
    NuevoI is I,
    calcula_num(_,Max,NuevoI, Lista):-!.

calcula_num(Max, I, X):-
    cuenta(Val,Num_FV),
    num_fichas_op(Num_FOP),
    num_fichas_dbw(Num_FDBW),
    combinaciones(Num_FV,I,Comb1),
    Num_F is 28 - Num_FOP - Num_FDBW,
    ResManoJ2 is Num_FOP - I,  
    combinaciones(Num_F,ResManoJ2,Comb2),
    X is Comb1*Comb2.

puede_poner_dbw([X,Y]):-
   derecho(X),!;
   izquierdo(X),!;
   derecho(Y),!;
   izquierdo(Y),!.

puede_ganar_dbw:-
    num_fichas_dbw(1).

perdio_dbw:-
    num_fichas_op(0).
empate:-
    derecho(ValD), izquierdo(ValI),
    cuenta([ValD, 0]),
    cuenta([ValI, 0]).
empate(ValI,ValD):-
    derecho(ValD), izquierdo(ValI),
    cuenta([ValD, 0]),
    cuenta([ValI, 0]).
