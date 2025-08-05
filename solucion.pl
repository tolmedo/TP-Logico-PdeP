% Solución en Prolog

% =========== Figuritas que existen: figurita(Numero, Imagen). ===========
% =========== imagen(Tipo, Personajes) ===========
% Posiblemente después haya que cambiarlo a que las figurtias sean numero e imagen. Y que luego la imagen tenga las divisiones de tipo y personajes
figurita(1, {basica, [kitty, keroppi]}). % Nivel = 8
figurita(2, {brillante, [kitty]}). % Nivel = 5*5 = 25
figurita(3, {brillante, [myMelody]}). % Nivel = 5*3 = 15
figurita(4, {basica, []}). % Nivel = 0
figurita(5, {rompecabezas1, [pompompurin]}). % Nivel = 0
figurita(6, {rompecabezas1, [gudetama]}). % Nivel = 0
figurita(7, {rompecabezas1, [badtzMaru]}). % Nivel = 0
figurita(8, {basica, [kitty, keroppi, cinnamon, badtzMaru, pompompurin, gudetama, myMelody, littleTwinStars, kuromi]}). % Nivel = 29
figurita(9, {basica, [littleTwinStars]}). % Nivel = 2

% =========== Generador de rompecabezas ===========

esRompecabezas(rompecabezas1).
esRompecabezas(rompecabezas2). % Por las dudas
esRompecabezas(rompecabezas3). % Por las dudas

% =========== Figuritas que actualmente tiene cada persona: tiene(Persona, Figus). ===========

tiene(andy, [1, 2, 3, 4, 5, 6, 7, 8]).             
tiene(flor, [2, 4, 5, 7]).  
tiene(bobby, [1, 3, 4, 5, 6, 7]).     
tiene(pablito, [1, 2, 6]). 
tiene(toto, [1, 6]).     
tiene(lala, [1, 3, 5, 7]). 

% Juanchi no tiene ninguna figurita
% La figurita 9 no la tiene nadie

cantidadColeccionistas(7).
% Para el predicado: mitadPersonas(Figurita):-

% =========== Paquetes abiertos: paquete(Persona, N°Paquete, [Figuritas]). ===========

paquete(andy, 1, [2,4]).
paquete(andy, 2, [7,6]).
paquete(andy, 3, [8,1,3,5]).
paquete(flor, 1, [5]).
paquete(flor, 2, [5]).
paquete(bobby, 1, [3,5]).
paquete(bobby, 2, [7]).
paquete(lala, 1, [3,7,1]).
paquete(toto, 1, [1]).

% =========== Figuritas canjeadas: canje(Persona1, Persona2, Recibe1, Recibe2). ===========

canje(flor, andy, [4,7], [1]).
canje(flor, bobby, [2], [1,4,6]).
canje(pablito, lala, [1], [5]).
canje(pablito, toto, [2], [6]).

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

% =========== Saber si una persona tiene un figurita repetida ===========

repetida(Persona, Figurita):-
    tiene(Persona, Figus),
    member(Figurita, Figus),
    vecesObtenidas(Persona, Figurita, Veces),
    Veces > 1.

obtuvoFigurita(Persona, Figurita):-
    paquete(Persona, _, FigusPaquete),
    member(Figurita, FigusPaquete).

obtuvoFigurita(Persona, Figurita):- canje(Persona, _, [Figurita], _).
obtuvoFigurita(Persona, Figurita):- canje(_, Persona, _ , [Figurita]).

vecesObtenidas(Persona, Figurita, Veces):-
    findall(Figurita, obtuvoFigurita(Persona, Figurita), Lista),
    length(Lista, Veces).

% =========== Saber si una figurita es rara ===========

esRara(Figurita):-
    figurita(Figurita, _),
    not(obtuvoEnPrimerosDosPaquetes(Figurita)).

esRara(Figurita):-
    figurita(Figurita, _),
    mitadPersonas(Figurita),
    not(repetida(_, Figurita)).
    
obtuvoEnPrimerosDosPaquetes(Figurita):-
    paquete(_, Paquete, FigusPaquete),
    Paquete < 3,
    member(Figurita, FigusPaquete).

mitadPersonas(Figurita):-
    findall(Persona, (tiene(Persona, Figus), member(Figurita, Figus)), ListaPersonas),
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
   figurita(Figurita, {brillante, Personajes}),
   member(P, Personajes),
   popularidad(P, Popularidad),
   Nivel is Popularidad*5.

nivelDeAtractivo(Figurita, Nivel):-
    figurita(Figurita, {basica, Personajes}),
    findall(Popularidad, (member(P, Personajes), popularidad(P, Popularidad)), ListaPopularidad),
    sumlist(ListaPopularidad, Nivel).
    
nivelDeAtractivo(Figurita, Nivel):-
    figurita(Figurita, {Tipo, _}),
    esRompecabezas(Tipo),
    findall(Figus, figurita(Figus, {Tipo, _}), Piezas),
    length(Piezas, CantPiezas),
    valorPiezas(CantPiezas, Nivel).

valorPiezas(CantPiezas, 0):- CantPiezas > 2.
valorPiezas(CantPiezas, 2):- CantPiezas =< 2.

% =========== Imagen más atractiva ===========

laMasAtractiva(Persona, Imagen):-
    tiene(Persona, Figus),
    member(Figurita, Figus),
    figurita(Figurita, Imagen),
    nivelDeAtractivo(Figurita, Nivel),
    forall(((tiene(Persona, OtrasFigus), member(OtraFigurita, OtrasFigus)), nivelDeAtractivo(OtraFigurita, OtroNivel)), Nivel >= OtroNivel).

% =========== Nivel de interés ===========

nivelDeInteresTotal(Persona, Figuritas, InteresTotal):-
    findall(Atractivo, (member(F, Figuritas), interesParcial(Persona, F, Atractivo)), Lista),
    sumlist(Lista, InteresParcial),
    plusRara(Figuritas, Agregado),
    InteresTotal is InteresParcial + Agregado.
    
interesParcial(Persona, Figurita, 0) :-
    tiene(Persona, Figus),
    member(Figurita, Figus).
interesParcial(Persona, Figurita, Interes) :- 
    nivelDeAtractivo(Figurita, Interes),
    not((tiene(Persona, Figus), member(Figurita, Figus))).

plusRara(Figuritas, 20) :-
    member(F, Figuritas),
    esRara(F).
plusRara(_,0).

% =========== Análisis elemental (Tomás) ===========


% =========== Hace negocio (Thiago) ===========

% =========== Necesita con urgencia (Maxi) ===========

% =========== Es una amenaza (Mateo) ===========

% =========== Canjes válidos (Sheila y ¿Maxi?) ===========

% 11 depende de 9 y 10, 12 depende de 8
