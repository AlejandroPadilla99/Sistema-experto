:- dynamic enfermedad/1.

enfermedad(fobia) :-
    is_true("¿Tiene deterioro social?"),
    is_true("¿Presenta llantos?"),
    is_true("¿Presenta rabietas?"),
    is_true("¿Presenta paralisis?"),
    is_true("Presenta sucesos traumaticos?"),
    is_true("Suele evitar situaciones?").
enfermedad(ansiedad) :-
    is_true("¿Tiene ansiedad?"),
    is_true("¿Se encuentra preocupado?"),
    is_true("¿Se haya inquieto?"),
    is_true("¿Se fatiga con facilidad?"),
    is_true("¿No puede concentrarse facilmente?"),
    is_true("¿Esta irritable?"),
    is_true("¿Padece tension muscular?"),
    is_true("¿Tiene dificultades para dormir?"),
    is_true("¿Tiene dificultades para controlar su preocupacion?").
enfermedad(depresionP) :-
    is_true("¿Tiene depresion?"),
    is_true("Si es ninio o adolescente ¿Esta irritable?"),
    is_true("¿Tiene poco apetito?"),
    is_true("¿Se sobrealimenta?"),
    is_true("¿Tiene fatiga?"),
    is_true("¿Tiene baja autoestima?"),
    is_true("¿Tiene problemas para concentrarse?"),
    is_true("¿Estos síntomas son persistentes?").
enfermedad(depresionM) :-
    is_true("¿Tiene depresion?"),
    is_true("¿Presenta perdida o aumento de peso repentino?"),
    is_true("¿Presenta perdida de apetito o aumento de apetito repentino?"),
    is_true("¿Presenta fatiga?"),
    is_true("¿Presenta falta de concentracion?"),
    is_true("¿Presenta malestar significativo?").
enfermedad(agorafobia) :-
    is_true("¿Tiene miedo a usar el transporte publico?"),
    is_true("¿Tiene miedo a espacios abiertos"),
    is_true("¿Ha tenido ataques de panico?"),
    is_true("¿Le preocupa tener ataques otra vez?"),
    is_true("¿Necesita estar acompañado de alguien en publico?"),
    is_true("¿Evita estar en lugares publicos?").
enfermedad(duelepansa) :-
    is_true("Hola"),
    is_true("mundo").

