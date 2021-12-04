:- use_module(library(pce)).
:- use_module(library(pce_style_item)).

menu:- 
    consult('trastornos'),
    new(Menu,dialog('Sistema experto')),
    new(L,label(titulo,'Menu inicial')),
    new(IniciarB,button('Iniciar',message(@prolog,query(Menu))),
    send(Menu,append(IniciarB)),
    send(Menu,append(L)),
    send(Menu,open_centered).

query(M):-
    send(M,free),
    new(Submen,dialog('Consulta')),
    new(L2,label(answer,'Usted sufre')),
    send(Submen,append(L2)),
    send(Submen,open_centered).
