inicio :-
    consult("trastornos"),
    consult("reif"),
    enfermedad(X), write("Su enfermedad es "), write(X);
    not(enfermedad(_)), write("Usted no cuenta con ninguna enfermedad"). 

enfermedad(A) :-
    enfermedades(Enfermedades),
    Known0 = [],
    phrase(any_enfermedad(Enfermedades, A), [Known0], _).

any_enfermedad([Enfermedad|Enfermedades], A) -->
    any_enfermedad_(Enfermedad, Enfermedades, A).

any_enfermedad_(enfermedad(A0, []), Enfermedades, A) -->
    (   { A0 = A }
    ;   any_enfermedad(Enfermedades, A)
    ).
any_enfermedad_(enfermedad(A0, [C|Cs]), Enfermedades, A) -->
    state0_state(Known0, Known),
    { condition_truth(C, T, Known0, Known) },
    next_enfermedad(T, enfermedad(A0,Cs), Enfermedades, A).

next_enfermedad(yes, Enfermedad, Enfermedades, A)  --> any_enfermedad([Enfermedad|Enfermedades], A).
next_enfermedad(no, _, Enfermedades, A)        --> any_enfermedad(Enfermedades, A).

state0_state(S0, S), [S] --> [S0].

condition_truth(is_true(Q), Answer, Known0, Known) :-
    if_(known_(Q,Answer,Known0),
        Known0 = Known,
        ( format("~w\n", [Q]),
            read(Answer),
            Known = [known(Q,Answer)|Known0])).

known_(What, Answer, Known, Truth) :-
    if_(memberd_t(known(What,yes), Known),
        ( Answer = si, Truth = true ),
        if_(memberd_t(known(What,no), Known),
            ( Answer = no, Truth = true),
            Truth = false)).
