:- use_module(library(pce)).
:- use_module(library(pce_style_item)).


%   menu principal
menu:-
    consult('trastornos'),
	new(Menu, dialog('Sistema experto', size(1000,800))),
	new(L,label(nombre,'Menu principal del sistema experto')),
	new(Texto,label(nombre,'Ingrese una opcion: ')),
	new(Respl,label(nombre,'')),
	new(Salir,button('SALIR',and(message(Menu, destroy), message(Menu,free)))),
	new(Boton,button('Realizar test',message(@prolog,consulta))),
    new(Botondos, button('Insertar enfermedad', message(@prolog, insertar_preguntas, prolog([])))),
	send(Menu,append(L)),
	send(Menu,append(Texto)),
	send(Menu,append(Boton)),
    send(Menu,append(Botondos)),
	send(Menu,append(Salir)),
	send(Menu,append(Respl)),
	send(Menu,open_centered).

% Agrega un nuevo conocimiento
insertar_preguntas(L) :-
    new(D, dialog('Insertar enfermedad')),
    new(T, text_item('Escriba una pregunta para identificar la enfermedad')),
    new(B1, button('Agregar pregunta', message(@prolog, insertar_en_lista, D, T, prolog(L)))),
    new(B2, button('Finalizar', message(@prolog, finalizar, D, prolog(L)))),
    send(D, append(T)),
    send(D, append(B1)),
    send(D, append(B2)),
    send(D, open_centered).

insertar_en_lista(D, T, L) :-
    get(T, selection, Text),
    Q = is_true(Text),
    append(L, [Q], NL),
    free(D),
    insertar_preguntas(NL).

finalizar(DO, []) :-
    free(DO),
    new(D, dialog('Insertar enfermedad')),
    new(T, label(texto, 'Su enfermedad debe contener al menos una pregunta')),
    send(D, append(T)),
    send(D, open_centered).

finalizar(DO, L) :-
    free(DO),
    new(D, dialog('Insertar enfermedad')),
    new(T, text_item('Escriba el nombre de la enfermedad')),
    new(B, button('Anadir enfermedad', message(@prolog, agregar_enfermedad, D, T, prolog(L)))),
    send(D, append(T)),
    send(D, append(B)),
    send(D, open_centered).

agregar_enfermedad(D, T, L) :-
    get(T, selection, Text),
    free(D),
    (
        Text == '',
        enfermedad_no_agregada
        ;
        crate_a_rule(Text, L),
        enfermedad_agregada
    ).

enfermedad_agregada :-
    new(D, dialog('Insertar enfermedad')),
    new(T, label(texto, 'Enfermedad agregada')),
    send(D, append(T)),
    send(D, open_centered).

enfermedad_no_agregada :-
    new(D, dialog('Insertar enfermedad')),
    new(T, label(texto, 'Su enfermedad debe de tener un nombre')),
    send(D, append(T)),
    send(D, open_centered).

%Menu de consulta

consulta:-
    new(Res,dialog('Sistema experto')),
    new(L2,label(texto,'Usted sufre de:')),
    (
        enfermedad(X),    
        new(Ans,label(ans,X))
        ;
        new(Ans,label(ans,"Sus sintomas no corresponden con ninguna de las enfermedades registradas."))
    ),
    send(Res,append(L2)),
    send(Res,append(Ans)),
    send(Res,open_centered),
    limpiar.

%Ventana que muestra las preguntas correspondientes a cada trastorno
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

% Limpia memoria
limpiar :- retract(si(_)),fail.
limpiar :- retract(no(_)),fail.
limpiar.


%crea una nueva regla en la base de datos y la inserta
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

%Guarda los cambios en la base de datos
save:-
    tell('trastornos.pl'),
    listing(enfermedad),
    told().
