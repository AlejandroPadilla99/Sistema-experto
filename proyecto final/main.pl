inicio :-
    consult("trastornos"),
    enfermedad(X), write("Su enfermedad es "), write(X); not(enfermedad(_)), write("Usted no cuenta con ninguna enfermedad"). 


is_true(Q) :-
        format("~w\n", [Q]),
        read(yes).
/* Ingresar una nueva regla */
 make_rule:-
    write("Ingresa en nombre de la enfermedad"),read(S),
    add_questions([],Lista),
    write(Lista).

add_questions(L,Lista):-
    write("Ingrese una pregunta entre comilla porvafor GRACIAS"),read(Q),
    Question = is_true(Q),
    Temp = [Question|L],
    write("Ingrese 1 para ingresar otra pregunta"),read(Ans),
    (Ans = 1 ->
        add_questions(Temp,Lista)
        ;
        Lista = Temp
    ).

    


/* crear nuevo conocimiento */
 crate_a_rule(Name,Cond):- 
    list_to_tuple(Cond,Body),
    assert(enfermedad(Name):-Body),
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
