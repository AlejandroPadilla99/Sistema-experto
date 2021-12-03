:- use_module(library(pce)).
:- use_module(library(pce_style_item)).

%   menu principal
inicio:-
    consult('trastornos'),
	new(Menu, dialog('Sistema experto', size(1000,800))),
	new(L,label(nombre,'Menu principal del sistema experto')),
	new(@texto,label(nombre,'Ingrese la opcion: ')),
	new(@respl,label(nombre,'')),
	new(Salir,button('SALIR',and(message(Menu, destroy),message(Menu,free)))),
	new(@boton,button('realizar test',message(@prolog,consulta))),


	send(Menu,append(L)),new(@btncarrera,button('Diagnostico?')),
	send(Menu,display,L,point(125,20)),
	send(Menu,display,@boton,point(100,150)),
	send(Menu,display,@texto,point(20,100)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,@respl,point(20,130)),

	send(Menu,open_centered).

%Menu de consulta
consulta:-
    new(Res,dialog('Sistema experto')),
    new(L2,label(texto,'Usted sufre de:')),
    enfermedad(X),
    new(Ans,label(ans,X)), 
    send(Res,append(L2)),
    send(Res,append(Ans)),
    send(Res,open_centered).


%Ventana que muestra las correspondientes preguntas 
:-dynamic si/1, no/1.
preguntar(Pregunta):-
    new(Di,dialog('Diagnostico')),
    new(L2,label(texto,'Respode la siguiente pregunta')),
    new(La,label(pre,Pregunta)),
    new(B1,button(si,and(message(Di,return,si)))),
    new(B2,button(no,and(message(Di,return,no)))),

    send(Di,append(L2)),
    send(Di,append(La)),
    send(Di,append(B1)),
    send(Di,append(B2)),
    send(Di,open_centered),
    get(Di,confirm,Answer),
    write(Answer),
    send(Di,destroy),
    ( Answer = si ->
        assert(si(Pregunta))
        ;
	    assert(no(Pregunta)),
        fail
    ).


is_true(Q) :-
    (si(Q)->true;(no(Q)->fail; preguntar(Q))).


limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.

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


%crea un nueva regla en la vase de dados y la inserta
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

%Guarada los cambios en la base de datos
save:-
    tell('trastornos.pl'),
    listing(enfermedad),
    told().
