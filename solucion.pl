% Solución en Prolog

% =========== Figuritas que existen: figurita(Numero, Tipo, [Personajes]). ===========

figurita(1, basica, [kitty, keroppi]). % Nivel = 8
figurita(2, brillante, [kitty]). % Nivel = 5*5 = 25
figurita(3, brillante, [myMelody]). % Nivel = 5*3 = 15
figurita(4, basica, []). % Nivel = 0
figurita(5, rompecabezas1, [pompompurin]). % Nivel = 0
figurita(6, rompecabezas1, [gudetama]). % Nivel = 0
figurita(7, rompecabezas1, [badtzMaru]). % Nivel = 0
figurita(8, basica, [kitty, keroppi, cinnamon, badtzMaru, pompompurin, gudetama, myMelody, littleTwinStars, kuromi]). % Nivel = 29
figurita(9, basica, [littleTwinStars]). % Nivel = 2

% =========== Generador de rompecabezas ===========

esRompecabezas(rompecabezas1).
esRompecabezas(rompecabezas2). % Por las dudas
esRompecabezas(rompecabezas3). % Por las dudas

% =========== Figuritas que actualmente tiene cada persona: tiene(Persona, Figurita). ===========

tiene(andy, 2). 
tiene(andy, 4). 
tiene(andy, 6). 
tiene(andy, 7).    
tiene(andy, 8).    
tiene(andy, 1).    
tiene(andy, 3).    
tiene(andy, 5).    
tiene(flor, 5). 
tiene(flor, 4). 
tiene(flor, 7). 
tiene(flor, 2). 
tiene(bobby, 1). 
tiene(bobby, 4). 
tiene(bobby, 6).
tiene(bobby, 3).    
tiene(bobby, 5).    
tiene(bobby, 7).    
tiene(pablito, 1). 
tiene(pablito, 2). 
tiene(pablito, 6).
tiene(toto, 1).    
tiene(toto, 2).
tiene(toto, 6). 
tiene(lala, 3). 
tiene(lala, 7). 
tiene(lala, 1). 
tiene(lala, 5). 

% Juanchi no tiene ninguna figurita
% La figurita 9 no la tiene nadie

cantidadColeccionistas(7). % Para el predicado: mitadPersonas(Figurita):-

% =========== Paquetes abiertos: abrio(Persona, N°Paquete, [Figuritas]). ===========

abrio(andy, 1, [2,4]).
abrio(andy, 2, [7,6]).
abrio(andy, 3, [8,1,3,5]).
abrio(flor, 1, [5]).
abrio(flor, 2, [5]).
abrio(bobby, 1, [3,5]).
abrio(bobby, 2, [7]).
abrio(lala, 1, [3,7,1]).
abrio(toto, 1, [1]).

% =========== Figuritas recibidas: recibio(Receptor, regalo(De, Figurita)). ===========

recibio(flor, regalo(andy, 4)).
recibio(flor, regalo(andy, 7)).
recibio(flor, regalo(bobby, 2)).
recibio(andy, regalo(flor, 1)).
recibio(bobby, regalo(flor, 1)).
recibio(bobby, regalo(flor, 4)).
recibio(bobby, regalo(flor, 6)).
recibio(pablito, regalo(lala, 1)).
recibio(pablito, regalo(toto, 2)).
recibio(lala, regalo(pablito, 5)).
recibio(toto, regalo(pablito, 6)).

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
    tiene(Persona, Figurita),
    vecesObtenidas(Persona, Figurita, Veces),
    Veces > 1.

obtuvoFigurita(Persona, Figurita):-
    abrio(Persona, _, Lista),
    member(Figurita, Lista).

obtuvoFigurita(Persona, Figurita):-
    recibio(Persona, regalo(_, Figurita)).

vecesObtenidas(Persona, Figurita, Veces):-
    findall(Figurita, obtuvoFigurita(Persona, Figurita), Lista),
    length(Lista, Veces).

% =========== Saber si una figurita es rara ===========

esRara(Figurita):-
    figurita(Figurita, _, _),
    not(obtuvoEnPrimerosDosPaquetes(Figurita)).

esRara(Figurita):-
    figurita(Figurita, _, _),
    mitadPersonas(Figurita),
    not(repetida(_, Figurita)).
    
obtuvoEnPrimerosDosPaquetes(Figurita):-
    abrio(_, Paquete, Lista),
    Paquete < 3,
    member(Figurita, Lista).

mitadPersonas(Figurita):-
    findall(Persona, tiene(Persona, Figurita), ListaPersonas),
    length(ListaPersonas, CantidadPersonas),
    cantidadColeccionistas(Coleccionistas),
    Mitad is Coleccionistas // 2,
    CantidadPersonas < Mitad.

% =========== Saber si una figurita es valiosa ===========

esValiosa(Figurita):-
    esRara(Figurita).
%esValiosa(Figurita):-
%  nivelDeAtractivo(Figurita, Nivel),
%  Nivel > 7.

% *La comento para que no tire error*. 


% En este punto faltaría el predicado: nivelDeAtractivo(Figurita, Nivel):-
% Si es BÁSICA -> suma la popularidad de todos los personajes -> se puede con un findall y dsp sumlist
% Si es BRILLANTE -> agarra la popularidad del personaje y la multiplica por 5 -> Nivel is Popularidad * 5
% Si es ROMPECABEZAS -> tiene hasta dos partes, sería algo como: figurita(F, Tipo, _), esRompecabezas(Tipo), *buscar cuantas partes de ese rompecabezas existen, puede ser con un findall*.
                        % Si la CantidadPartes > 2 -> NIVEL = 0.
                        % Si la CantidadPartes =< 2 -> NIVEL = 2.

% Arriba están todos los valores del NIVEL que debería dar (si los calculé bien).