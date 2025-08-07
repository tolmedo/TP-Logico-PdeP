% Solución en Prolog

% =========== Figuritas que existen: figurita(Numero, Imagen). ===========
% =========== imagen(Tipo, Personajes) ===========

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
esRompecabezas(rompecabezas2). % Demostración de como agregar rompecabezas
esRompecabezas(rompecabezas3). % Demostración de como agregar rompecabezas

% =========== Figuritas que actualmente tiene cada persona: tiene(Persona, Figus). ===========

tiene(andy, [1,2,3,4,5,6,7,8]).             
tiene(flor, [2,4,5,7]).  
tiene(bobby, [1,3,4,5,6,7]).     
tiene(pablito, [1,2,6]). 
tiene(toto, [1,6]).     
tiene(lala, [1,3,5,7]). 

cantidadColeccionistas(7).

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
canje(flor, bobby, [3], [5]).
canje(pablito, lala, [1], [5]).
canje(pablito, toto, [2], [6]).
canje(flor, pablito, [6], [2]).

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

% =========== Saber si una persona tiene un figurita repetida ===========

repetida(Persona, Figurita):-
    tiene(Persona, Figus),
    member(Figurita, Figus),
    vecesObtenidas(Persona, Figurita, Veces),
    Veces > 1.

obtuvoFigurita(Persona, Figurita):-
    paquete(Persona, _, FigusPaquete),
    member(Figurita, FigusPaquete).

obtuvoFigurita(Persona, Figurita):- canje(Persona, _, [Figurita], _). %Agregar member
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
plusRara(_,0). %Se Podría agregar para que verifique que ninguna sea rara. (cut en el de arriba)

% =========== Análisis elemental ===========

esValidoElCanje(Persona1, Persona2, Recibe1, Recibe2):-
    validarFiguritas(Persona1, Recibe2),
    validarFiguritas(Persona2, Recibe1). 
    
validarFiguritas(Persona, Figus):-
    tiene(Persona, FigusQueTiene),
    forall(member(FiguritaABuscar, Figus), member(FiguritaABuscar, FigusQueTiene)). %También verificar si las figuritas existen. (No solo que las tenga)

esValidoElPaquete(Figus):-
    forall(member(FiguritaABuscar, Figus), figurita(FiguritaABuscar, _)).

% =========== Hace negocio (Verificamos que la Persona1 haga negocio con la Persona2) ===========

haceNegocio(Persona, OtraPersona, Recibe, Entrega):-
    verificarCanje(Persona, OtraPersona, Recibe, Entrega),
    member(R, Recibe), 
    esValiosa(R),
    forall(member(E, Entrega), not(esValiosa(E))).

verificarCanje(Persona1, Persona2, Recibe1, Recibe2):- canje(Persona1, Persona2, Recibe1, Recibe2).
verificarCanje(Persona1, Persona2, Recibe1, Recibe2):- canje(Persona2, Persona1, Recibe2, Recibe1).

% =========== Necesita con urgencia ===========      

necesitaConUrgencia(Persona, Figurita) :-
    figurita(Figurita, _ ),
    tiene(Persona, FigusQueTiene),
    not(member(Figurita,FigusQueTiene)),
    completa(FigusQueTiene, Figurita).

% Caso de que sea una pieza del rompecabezas que tiene empezado
completa(FigusQueTiene, Figurita) :-
    figurita(Figurita, {Rompecabezas, _}),
    esRompecabezas(Rompecabezas),
    member(PiezaQueTiene, FigusQueTiene),
    figurita(PiezaQueTiene, {Rompecabezas, _}). 

% Caso de que sea la última que le falte del album
completa(FigusQueTiene, _) :-
    findall(CadaFiguAlbum, figurita(CadaFiguAlbum,_), TodasFigusAlbum),
    length(TodasFigusAlbum, CantFigusAlbum),
    length(FigusQueTiene, CantFigusQueTiene),
    CantFigusQueTiene is CantFigusAlbum-1.

% =========== Es una amenaza ===========
% No es en base a la histórica, sino que le mandamos la lista de canjes nosotros
esUnaAmenaza(Persona):- %Podríamos sacar el findall que le sigue un forall. Es más fácil que evalúe directamente
    verificarCanje(Persona, _, _, _),
    findall([OtraPersona, Recibe, Entrega], verificarCanje(Persona, OtraPersona, Recibe, Entrega), ListaCanjes),
    ListaCanjes \= [],
    member([OtraPersona, Recibe, Entrega], ListaCanjes),
    haceNegocio(Persona, OtraPersona, Recibe, Entrega),
    forall(member([OtraP, RecibeP, RecibeOtraP], ListaCanjes), salioGanando(Persona, OtraP, RecibeP, RecibeOtraP)).

salioGanando(Persona, OtraPersona, RecibePersona, RecibeOtraPersona):-
    nivelDeInteresTotal(Persona, RecibePersona, InteresDePersona), 
    nivelDeInteresTotal(OtraPersona, RecibeOtraPersona, InteresDelOtro),
    InteresDePersona > InteresDelOtro.

/* 
%Versión con otra alternativa, el interés es solo desde el punto de vista de la persona que mandamos.
salioGanando(Persona, OtraPersona, RecibePersona, RecibeOtraPersona):-
    nivelDeInteresTotal(Persona, Recibe, InteresR), 
    nivelDeInteresTotal(Persona, Entrega, InteresE),
    InteresR > InteresE.
*/

% =========== Canjes válidos ===========

tipoDeColeccionista(andy, []).
tipoDeColeccionista(flor, [descartador]).
tipoDeColeccionista(bobby, [cazafortunas]).
tipoDeColeccionista(pablito, [descartador]). 
tipoDeColeccionista(toto, [urgido, clasico]).
tipoDeColeccionista(lala, [clasico]). 

% Falta que las figuritas sean inversibles (Considerar recursividad).
posiblesCanjesValidos(Persona1, Persona2, EntregaDel2, EntregaDel1):-
    esValidoElCanje(Persona1, Persona2, EntregaDel2, EntregaDel1),
    member(FiguritaIndv, EntregaDel1), 
    repetida(Persona1, FiguritaIndv),
    tipoDeColeccionista(Persona2, ListaColeccionista),
    member(TipoColeccionistaIndv, ListaColeccionista),
    detectarEstiloColeccionista(TipoColeccionistaIndv, Persona2, EntregaDel1, EntregaDel2).

% ------ CLASICO: La persona2 no tiene ninguna figurita que la Persona1 le entrega ------
detectarEstiloColeccionista(clasico, Persona2, EntregaDel1,_):-
    forall(member(Figurita, EntregaDel1), not((tiene(Persona2, Lista), member(Figurita, Lista)))). 

% ------DESCARTADOR: la Persona2 solo entrega figuritas repetidas ------
detectarEstiloColeccionista(descartador, Persona2, _, EntregaDel2):-
    forall(member(Figurita2, EntregaDel2), repetida(Persona2, Figurita2)). 

% ------ CAZAFORTUNAS: alguna figurita de lo que entregaEl1 es valiosa ------
detectarEstiloColeccionista(cazafortunas,_, EntregaDel1,_ ):-
    member(Figurita, EntregaDel1),
    esValiosa(Figurita).                    

% ------ URGIDO: alguna figurita de lo que entregaEl1 la necesita con urgencia ------
detectarEstiloColeccionista(urgido ,Persona2, EntregaDel1, _):-
    member(Figurita, EntregaDel1),
    necesitaConUrgencia(Persona2,Figurita).


/*
Tenemos un enfoque demasiado procedural, intentar aprovechar más las herramientas del paradigma lógico.
*/