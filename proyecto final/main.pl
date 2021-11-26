inicio :-
    consult("trastornos"),
    consult("reif"),
    enfermedad(X), write("Su enfermedad es "), write(X);
    not(enfermedad(_)), write("Usted no cuenta con ninguna enfermedad"). 


is_true(Q) :-
        format("~w\n", [Q]),
        read(yes).


/* crear nuevo conocimiento */
 crate_a_rule:-
    Cond=[is_true("Hola"),is_true("mundo")],
    list_to_tuple(Cond,Body),
    assert(enfermedad(duelepansa):-Body),
    save.

list_to_tuple([],_) :- 
    ValidDomain='[x|xs]',
    Culprit='[]',
    Formal=domain_error(ValidDomain, Culprit),
    Context=context('list_to_tuple','Cannot create empty tuple!'),
    throw(error(Formal,Context)).

list_to_tuple([X],X).

list_to_tuple([H|T],(H,Rest_Tuple)) :-
    list_to_tuple(T,Rest_Tuple).

/*  guardar los nuevos conocimientos */
save:-
    tell('trastornos.pl'),
    listing(enfermedad),
    told().
