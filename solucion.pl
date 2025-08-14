% Solución en Prolog

% =========== Figuritas que existen: figurita(Numero, Tipo). ===========
% =========== Tipo(Personajes) ===========

figurita(1, basica([kitty, keroppi])). % Nivel = 8
figurita(2, brillante([kitty])). % Nivel = 5*5 = 25
figurita(3, brillante([myMelody])). % Nivel = 5*3 = 15
figurita(4, basica([])). % Nivel = 0
figurita(5, rompecabezas(1, [pompompurin])). % Nivel = 0
figurita(6, rompecabezas(1, [gudetama])). % Nivel = 0
figurita(7, rompecabezas(1, [badtzMaru])). % Nivel = 0
figurita(8, basica([kitty, keroppi, cinnamon, badtzMaru, pompompurin, gudetama, myMelody, littleTwinStars, kuromi])). % Nivel = 29
figurita(9, basica([littleTwinStars])). % Nivel = 2

cantidadColeccionistas(7).

% =========== Paquetes abiertos: obtuvoEnPaquete(Persona, N°Paquete, Figurita). ===========

obtuvoEnPaquete(andy, 1, 2).
obtuvoEnPaquete(andy, 1, 4).
obtuvoEnPaquete(andy, 2, 6).
obtuvoEnPaquete(andy, 2, 7).
obtuvoEnPaquete(andy, 3, 8).
obtuvoEnPaquete(andy, 3, 1).
obtuvoEnPaquete(andy, 3, 3).
obtuvoEnPaquete(andy, 3, 5).
obtuvoEnPaquete(flor, 1, 5).
obtuvoEnPaquete(flor, 2, 5).
obtuvoEnPaquete(bobby, 1, 3).
obtuvoEnPaquete(bobby, 1, 5).
obtuvoEnPaquete(bobby, 2, 7).
obtuvoEnPaquete(lala, 1, 3).
obtuvoEnPaquete(lala, 1, 7).
obtuvoEnPaquete(lala, 1, 1).
obtuvoEnPaquete(toto, 1, 1).

% =========== Figuritas canjeadas: obtuvoEnCanje(Persona, Figurita). ===========

obtuvoEnCanje(flor, 7).
obtuvoEnCanje(flor, 4).
obtuvoEnCanje(flor, 2).
obtuvoEnCanje(andy, 1).
obtuvoEnCanje(bobby, 1).
obtuvoEnCanje(bobby, 4).
obtuvoEnCanje(bobby, 5).
obtuvoEnCanje(bobby, 6).
obtuvoEnCanje(pablito, 1).
obtuvoEnCanje(pablito, 2).
obtuvoEnCanje(pablito, 5).
obtuvoEnCanje(toto, 6).
obtuvoEnCanje(lala, 5).

% caso de prueba punto 11 (ademas ponerle porcentaje al primer canje y borrarle el 2 a andy)
% canje(andy, pablito, [1], [8]). % NO es una amenaza
% canje(andy, flor, [2], [5]). % Es una amenaza

% =========== Popularidad de los personajes: popularidad(Personaje, Popularidad). ===========

popularidad(kitty, 5).
popularidad(cinnamon, 4).
popularidad(badtzMaru, 2).
popularidad(keroppi, 3).
popularidad(pompompurin, 4).
popularidad(gudetama, 1).
popularidad(myMelody, 3).
popularidad(littleTwinStars, 2).
popularidad(kuromi, 5).

% =========== tipoDeColeccionista(Persona, Rol). ===========

descartador(flor).
descartador(pablito).
cazafortunas(bobby).
clasico(toto).
clasico(lala).
urgido(toto).
urgido(andy).

% =========== Saber si una persona tiene un figurita repetida ===========

esRepetida(Persona, Figurita):-
    obtuvoFigurita(Persona, Figurita),
    findall(Figurita, obtuvoFigurita(Persona, Figurita), Lista),
    length(Lista, Veces),
    Veces > 1.

obtuvoFigurita(Persona, Figurita):- obtuvoEnPaquete(Persona,_, Figurita).
obtuvoFigurita(Persona, Figurita):- obtuvoEnCanje(Persona, Figurita).

% =========== Saber si una figurita es rara ===========

esRara(Figurita):-
    figurita(Figurita, _),
    not(obtuvoEnPrimerosDosPaquetes(Figurita)).

esRara(Figurita):-
    figurita(Figurita, _),
    mitadPersonas(Figurita),
    not(esRepetida(_, Figurita)).
    
obtuvoEnPrimerosDosPaquetes(Figurita):-
    obtuvoEnPaquete(_, Paquete, Figurita),
    Paquete < 3.

mitadPersonas(Figurita):-
    figurita(Figurita, _),
    findall(Persona, obtuvoFigurita(Persona, Figurita), ListaPersonas),
    length(ListaPersonas, CantidadPersonas),
    cantidadColeccionistas(Coleccionistas),
    Mitad is Coleccionistas / 2,
    CantidadPersonas < Mitad.

% =========== Saber si una figurita es valiosa ===========

esValiosa(Figurita):-
    esRara(Figurita).
esValiosa(Figurita):-
    nivelDeAtractivo(Figurita, Nivel),
    Nivel > 7.

nivelDeAtractivo(Figurita, Nivel):-
   figurita(Figurita, brillante(Personajes)),
   member(P, Personajes),
   popularidad(P, Popularidad),
   Nivel is Popularidad*5.

nivelDeAtractivo(Figurita, Nivel):-
    figurita(Figurita, basica(Personajes)),
    findall(Popularidad, (member(P, Personajes), popularidad(P, Popularidad)), ListaPopularidad),
    sumlist(ListaPopularidad, Nivel).
    
nivelDeAtractivo(Figurita, Nivel):-
    figurita(Figurita, rompecabezas(X,_)),
    findall(Figus, figurita(Figus, rompecabezas(X,_)), Piezas),
    length(Piezas, CantPiezas),
    valorPiezas(CantPiezas, Nivel).

valorPiezas(CantPiezas, 0):- CantPiezas > 2.
valorPiezas(CantPiezas, 2):- CantPiezas =< 2.

% =========== Imagen más atractiva ===========

laMasAtractiva(Persona, Imagen):-
    obtuvoFigurita(Persona, Figurita),
    figurita(Figurita, Imagen),
    nivelDeAtractivo(Figurita, Nivel),
    forall((obtuvoFigurita(Persona, OtraFigurita), nivelDeAtractivo(OtraFigurita, OtroNivel)), Nivel >= OtroNivel).

% =========== Nivel de interés ===========

nivelDeInteresTotal(Persona, Figuritas, InteresTotal):-
    findall(Atractivo, (member(F, Figuritas), interesParcial(Persona, F, Atractivo)), Lista),
    sumlist(Lista, InteresParcial),
    plusRara(Figuritas, Agregado),
    InteresTotal is InteresParcial + Agregado.
    
interesParcial(Persona, Figurita, 0) :- obtuvoFigurita(Persona, Figurita).
interesParcial(Persona, Figurita, Interes) :- 
    nivelDeAtractivo(Figurita, Interes),
    not(obtuvoFigurita(Persona, Figurita)).

plusRara(Figuritas, 20) :-
    member(F, Figuritas),
    esRara(F).
plusRara(Figuritas,0) :-
    forall(member(F, Figuritas), not(esRara(F))).

% =========== Análisis elemental ===========

esValidoElCanje(Persona1, Persona2, Entrega1, Entrega2):-
    validarFiguritas(Persona1, Entrega1),
    validarFiguritas(Persona2, Entrega2).
    
validarFiguritas(Persona, Figus):- forall(member(Figurita,Figus), (figurita(Figurita,_), obtuvoFigurita(Persona, Figurita))).

esValidoElPaquete(Figus):- forall(member(FiguritaABuscar, Figus), figurita(FiguritaABuscar, _)).

% =========== Hace negocio (Verificamos que la Persona1 haga negocio con la Persona2) ===========

haceNegocio(Persona, OtraPersona, Entrega, Recibe) :-
    esValidoElCanje(Persona, OtraPersona, Entrega, Recibe), 
    member(R, Recibe), 
    esValiosa(R),
    forall(member(E, Entrega), not(esValiosa(E))).

% =========== Necesita con urgencia ===========

necesitaConUrgencia(Persona, Figurita) :-
    figurita(Figurita, _),
    obtuvoFigurita(Persona, _),
    not(obtuvoFigurita(Persona, Figurita)),
    completa(Persona, Figurita).

% Caso de que sea una pieza del rompecabezas que tiene empezado
completa(Persona, Figurita) :-
    figurita(Figurita, rompecabezas(Romp, _)),
    figurita(OtraFigurita, rompecabezas(Romp, _)),
    obtuvoFigurita(Persona, OtraFigurita).

% Caso de que sea la última que le falte del album
completa(Persona, Figurita) :-
    figurita(Figurita, _),
    forall((figurita(OtraFigurita,_), OtraFigurita \= Figurita), obtuvoFigurita(Persona, OtraFigurita)).

% =========== Es una amenaza ===========

esUnaAmenaza(Persona1,Canjes):-
    obtuvoFigurita(Persona1, _),
    member((Persona2, Entrega1, Entrega2), Canjes),
    esValidoElCanje(Persona1, Persona2, Entrega1, Entrega2),
    haceNegocio(Persona1, Persona2, Entrega1, Entrega2),
    forall(member((OtraPersona, OtraEntrega1, EntregaOtraPersona), Canjes), salioGanando(Persona1, OtraPersona, OtraEntrega1, EntregaOtraPersona)).

salioGanando(Persona, OtraPersona, Entrega, Recibe) :-
    esValidoElCanje(Persona, OtraPersona, Entrega, Recibe),
    nivelDeInteresTotal(Persona, Recibe, InteresDePersona),
    nivelDeInteresTotal(OtraPersona, Entrega, InteresDelOtro),
    InteresDePersona > InteresDelOtro.

% =========== Canjes válidos ===========

posiblesCanjesValidos(Persona1, Persona2, EntregaP1, EntregaP2):-
    recursivoTodosLosCanjes(Persona1, Persona2, EntregaP1, EntregaP2),
    member(Repetida, EntregaP1), 
    esRepetida(Persona1, Repetida),
    detectarEstiloColeccionista(Persona2, EntregaP1, EntregaP2).
    
% ------ CLASICO: La persona2 no tiene ninguna figurita que la Persona1 le entrega ------
detectarEstiloColeccionista(Persona2, EntregaP1,_):-
    clasico(Persona2),
    forall(member(Figurita, EntregaP1), not(obtuvoFigurita(Persona2, Figurita))).

% ------DESCARTADOR: la Persona2 solo entrega figuritas repetidas ------
detectarEstiloColeccionista(Persona2, _, EntregaP2):-
    descartador(Persona2),
    forall(member(Figurita, EntregaP2), esRepetida(Persona2, Figurita)). 

% ------ CAZAFORTUNAS: alguna figurita de lo que entregaEl1 es valiosa ------
detectarEstiloColeccionista(Persona2, EntregaP1,_ ):-
    cazafortunas(Persona2),
    member(Figurita, EntregaP1),
    esValiosa(Figurita).                    

% ------ URGIDO: alguna figurita de lo que entregaEl1 la necesita con urgencia ------
detectarEstiloColeccionista(Persona2, EntregaP1, _):-
    urgido(Persona2),
    member(Figurita, EntregaP1),
    necesitaConUrgencia(Persona2, Figurita).

subconjuntoNoVacio(Lista, Sub) :- % Permite generar todos los subconjuntos de una lista de figuritas (actúa como P(A)) 
    eligeFiguritas(Lista, Sub),
    Sub \= []. % Se filtra la lista vacía

eligeFiguritas([], []).
eligeFiguritas([PrimeraFigurita|Resto], [PrimeraFigurita|Elegidas]) :- eligeFiguritas(Resto, Elegidas).
eligeFiguritas([_|Resto], Elegidas) :- eligeFiguritas(Resto, Elegidas).

recursivoTodosLosCanjes(Persona1, Persona2, EntregaP1, EntregaP2):-
    obtuvoFigurita(Persona1, _),
    obtuvoFigurita(Persona2, _),
    Persona1 \= Persona2, 

    findall(F, obtuvoFigurita(Persona1, F), FigusP1),
    findall(F, obtuvoFigurita(Persona2, F), FigusP2),

    subconjuntoNoVacio(FigusP1, EntregaP1),
    subconjuntoNoVacio(FigusP2, EntregaP2),
    esValidoElCanje(Persona1, Persona2, EntregaP1, EntregaP2).