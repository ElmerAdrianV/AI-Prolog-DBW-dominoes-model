:- dynamic
    cons_factorial/2. %Nos dice si tenemos cierta ficha.

cons_factorial(0,1) :- !.

factorial(N,Resp) :-
    cons_factorial(N,Resp),! ;
    A is N-1,
    (cons_factorial(A,_) ->
        cons_factorial(A,Fact_n1)
        ;
        factorial(A, Fact_n1)
    ),
    Resp is N*Fact_n1,
    asserta(cons_factorial(N,Resp)).
combinaciones(N,K,Resp):-
    factorial(N,Fn),
    factorial(K,Fk),
    DifNK is N-K,
    factorial(DifNK,Fnk),
    Resp is Fn/(Fnk*Fk).
