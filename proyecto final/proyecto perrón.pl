% Sistema experto de trastornos
%
% Para iniciar el programa, escribe:
%
%  inicio.
%
% (con el punto al final, que esto es Prolog)
%
%
% Contacto:
%
% Telegram: @Juampa3i3 t.me/juampa3i3
% LoL: Juampa3i3
% Correo: estecorreosiexiste@writeme.com
%

% Es el archivo donde están los trastornos y sus síntomas
consultar_base:- consult('trastornos_bc.pl').

% Para limpiar la pantalla
limpiar :- write('\033[2J').

% Inicio del progama
inicio :- limpiar,
          consultar_base,
          write('----------------------------------------------------------\n'),
          write('|Cada vez que ingresas algún dato, pon un punto al final.|\n'),
          write('----------------------------------------------------------\n'),
          menú.

% Menú principal
menú :- write('Bienvenido al sistema experto de trastornos mentales\n'),
        write('Esta herramienta no sustituye a un médico.\nSi es necesario, acude a un especialista.\n'),
        write('Ingresa 1 para iniciar con las preguntas\n'),
        write('Ingresa cualquier otro valor para salir\n'),
        write('---------------------------------------------------\n'),
        write('---Ingresa una opción :'),
        read(Op),
        nl,
        switch(Op).

% Iniicio de preguntas
switch(1) :- pregunta1.

% Fin del programa
switch(_) :- write('¡Gracias por usar el programa!').

% Preguntas
pregunta1:- write("¿Se presenta ansiedad?"),
            read(Resp),
            respuesta(1,Resp).

pregunta2(Lista):- write('¿Se presenta miedo?'),
                   read(Resp),
                   respuesta(2,Resp,Lista).

pregunta3(Lista):- write('¿El paciente necesita compañía al sentir miedo?'),
                   read(Resp),
                   respuesta(3,Resp,Lista).

pregunta4(Lista):- write('¿El paciente se alimenta correctamente?'),
                   read(Resp),
                   respuesta(4,Resp,Lista).

pregunta5(Lista):- write('¿Se presenta depresión?'),
                   read(Resp),
                   respuesta(5,Resp,Lista).

pregunta6(Lista):- write('¿Persisten los síntomas?'),
                   read(Resp),
                   respuesta(6,Resp,Lista).

%Validación de respuestas
respuesta(1,sí):- insertar("ansiedad",[],Lista),pregunta2(Lista).
respuesta(1,si):- insertar("ansiedad",[],Lista),pregunta2(Lista).
respuesta(1,no):- insertar("no ansiedad",[],Lista),pregunta6(Lista).
respuesta(1,_):- write("Escribe sí o no\n"),pregunta1.

respuesta(2,sí,Lista):- insertar("miedo",Lista,Lista2),pregunta3(Lista2).
respuesta(2,si,Lista):- insertar("miedo",Lista,Lista2),pregunta3(Lista2).
respuesta(2,no,Lista):- insertar("no miedo",Lista,Lista2),pregunta5(Lista2).
respuesta(2,_,Lista):- write("Escribe sí o no\n"),pregunta2(Lista).

respuesta(3,sí,Lista):- insertar("necesita compañía",Lista,Lista2),pregunta4(Lista2).
respuesta(3,si,Lista):- insertar("necesita compañía",Lista,Lista2),pregunta4(Lista2).
respuesta(3,no,Lista):- insertar("no necesita compañía",Lista,Lista2),pregunta4(Lista2).
respuesta(3,_,Lista):- write("Escribe sí o no\n"),pregunta3(Lista).

respuesta(4,sí,Lista):- insertar("buena alimentación",Lista,Lista2),diagnosticar(Lista2).
respuesta(4,si,Lista):- insertar("buena alimentación",Lista,Lista2),diagnosticar(Lista2).
respuesta(4,no,Lista):- insertar("mala alimentación",Lista,Lista2),diagnosticar(Lista2).
respuesta(4,_,Lista):- write("Escribe sí o no\n"),pregunta4(Lista).

respuesta(5,sí,Lista):- insertar("depresión",Lista,Lista2),diagnosticar(Lista2).
respuesta(5,si,Lista):- insertar("depresión",Lista,Lista2),diagnosticar(Lista2).
respuesta(5,no,Lista):- insertar("no depresión",Lista,Lista2),diagnosticar(Lista2).
respuesta(5,_,Lista):- write("Escribe sí o no\n"),pregunta5(Lista).

respuesta(6,sí,Lista):- insertar("persisten los síntomas",Lista,Lista2),pregunta4(Lista2).
respuesta(6,si,Lista):- insertar("persisten los síntomas",Lista,Lista2),pregunta4(Lista2).
respuesta(6,no,Lista):- insertar("no persisten los síntomas",Lista,Lista2),pregunta4(Lista2).
respuesta(6,_,Lista):- write("Escribe sí o no\n"),pregunta6(Lista).

% Para diagnosticar el trastorno
% La lista se invierte porque la lista original está con la última
% respuesta al inicio, y al invertirla, la primera respuesta está al
% inicio.


% Si existe en la base de conocimientos, lo imprime
diagnosticar(Lista):- invierte(Lista,Lista2),
                      trastorno(Trast,Lista2),
                      write("\nLos criterios ingresados son:"),
                      write(Lista2),
                      write("\nEl trastorno es: "),
                      write(Trast),
                      nl,nl,
                      menú.

% Si no existe en la base de conocimientos, le pregunta al usuario si
% desea agregarla
diagnosticar(Lista):- invierte(Lista,Lista2),
                      \+ trastorno(_,Lista2),
                      write("\nLos criterios ingresados son:"),
                      write(Lista2),
                      write("\nNo sé cuál es el trastorno.\n¿Deseas ingresar uno nuevo?"),
                      read(O),
                      ingresarNuevo(O,Lista2).


% Para ingresar el nuevo trastorno a la base de conocimientos
ingresarNuevo(si,L):- write("\n¿Cómo se llama este trastorno?"),
                      read(Nombre),
                      assert(trastorno(Nombre,L)), % En esta línea se inserta el nuevo trastorno
                      tell('trastornos_bc.pl'), % Y en estas líneas se agrega al archivo
                      listing(trastorno),
                      told,
                      nl,
                      write("Se ha registrado el nuevo trastorno\n"),
                      menú.

ingresarNuevo(sí,L):- ingresarNuevo(si,L).

% Si el usuario no desea agregar el nuevo trastorno, se regresa al menú
ingresarNuevo(_,_):- menú.

%Operaciones con listas

%Insertar un elemento a una lista
insertar(E,L,[E|L]).

%Invertir el orden de la lista
invierte([],[]).
invierte([H|T],L):- invierte(T,R), concatena(R,[H],L).
concatena([],L,L).
concatena([X|L1],L2,[X|L3]):- concatena(L1,L2,L3).






