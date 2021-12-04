:- use_module(library(pce)).
:- use_module(library(pce_style_item)).

%   inicio
inicio:- 
    consult('trastornos'),
	new(Menu, dialog('Sistema experto', size(1000,800))),
    menu.

%   menu principal
menu:-
	new(Menu, dialog('Sistema experto', size(1000,800))),
	new(L,label(nombre,'Menu principal del sistema experto')),
	new(Texto,label(nombre,'Ingrese la opcion: ')),
	new(Respl,label(nombre,'')),
	new(Salir,button('SALIR',and(message(Menu, destroy), message(Menu,free)))),
	new(Boton,button('realizar test',message(@prolog,consulta))),
    new(Botondos, button('Insertar enfermedad', message(@prolog, insertar_preguntas, prolog([])))),

	send(Menu,append(L)),
	send(Menu,display,L,point(125,20)),
	send(Menu,display,Boton,point(100,150)),
    send(Menu,display,Botondos,point(100,250)),
	send(Menu,display,Texto,point(20,100)),
	send(Menu,display,Salir,point(20,400)),
	send(Menu,display,Respl,point(20,130)),
	send(Menu,open_centered).

insertar_preguntas(L) :-
    new(D, dialog('Insertar enfermedad')),
    new(T, text_item('Escriba una pregunta para identificar la enfermedad')),
    new(B1, button('Agregar pregunta', message(@prolog, insertar_en_lista, D, T, prolog(L)))),
    new(B2, button('Finalizar', message(@prolog, finalizar, D, prolog(L)))),
    send(D, append(T)),
    send(D, append(B1)),
    send(D, append(B2)),
    send(D, open).

insertar_en_lista(D, T, L) :-
    get(T, selection, Text),
    Q = is_true(Text),
    NL = [Q|L],
    free(D),
    insertar_preguntas(NL).

finalizar(DO, L) :-
    free(DO),
    new(D, dialog('Insertar enfermedad')),
    new(T, text_item('Escriba el nombre de la enfermedad')),
    new(B, button('Anadir enfermedad', message(@prolog, agregar_enfermedad, D, T, prolog(L)))),
    send(D, append(T)),
    send(D, append(B)),
    send(D, open).

agregar_enfermedad(D, T, L) :-
    get(T, selection, Text),
    crate_a_rule(Text, L),
    free(D).

%Menu de consulta

consulta:-
    new(Res,dialog('Sistema experto')),
    new(L2,label(texto,'Usted sufre de:')),
    enfermedad(X),
    new(Ans,label(ans,X)), 
    send(Res,append(L2)),
    send(Res,append(Ans)),
    send(Res,open_centered),
    limpiar.

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
