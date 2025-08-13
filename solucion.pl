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

/*
% =========== Generador de rompecabezas ===========

esRompecabezas(rompecabezas1).
esRompecabezas(rompecabezas2). % Demostración de como agregar rompecabezas
esRompecabezas(rompecabezas3). % Demostración de como agregar rompecabezas
*/

% =========== Figuritas que actualmente tiene cada persona: tiene(Persona, Figus). ===========

/*
tiene(andy, [1,2,3,4,5,6,7,8]).             
tiene(flor, [2,4,5,7]).  
tiene(bobby, [1,3,4,5,6,7]).     
tiene(pablito, [1,2,6]). 
tiene(toto, [1,6]).     
tiene(lala, [1,3,5,7]). 
*/

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

/*
tipoDeColeccionista(andy, []).
tipoDeColeccionista(flor, descartador).
tipoDeColeccionista(bobby, cazafortunas).
tipoDeColeccionista(pablito, descartador). 
tipoDeColeccionista(toto, urgido).
tipoDeColeccionista(toto, clasico).
tipoDeColeccionista(lala, clasico). 
*/
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
% revisar si es posible con forall

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
    member(F, Entrega1),
    obtuvoFigurita(Persona1, F),
    member(F2, Entrega2),
    obtuvoFigurita(Persona2, F2).
    %validarFiguritas(Persona1, Entrega1),
    %validarFiguritas(Persona2, Entrega2).
    
validarFiguritas(Persona, Figus):- forall(member(Figurita,Figus), (figurita(Figurita,_), obtuvoFigurita(Persona, Figurita))).

esValidoElPaquete(Figus):- forall(member(FiguritaABuscar, Figus), figurita(FiguritaABuscar, _)).

% =========== Hace negocio (Verificamos que la Persona1 haga negocio con la Persona2) ===========

haceNegocio(Persona, OtraPersona, Entrega, Recibe) :-
    %esValidoElCanje(Persona, OtraPersona, Entrega, Recibe), 
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
    %forall((figurita(OtraFigurita, rompecabezas(Romp,_)), obtuvoFigurita(Persona, OtraFigurita)), Figurita \= OtraFigurita).

% Caso de que sea la última que le falte del album
completa(Persona, Figurita) :-
    figurita(Figurita, _),
    %obtuvoFigurita(Persona, _),
    forall((figurita(OtraFigurita,_), OtraFigurita \= Figurita), obtuvoFigurita(Persona, OtraFigurita)).

% =========== Es una amenaza ===========

% No es en base a la histórica, sino que le mandamos la lista de canjes nosotros

esUnaAmenaza(Persona1, Canjes):-
    member((Persona2, Entrega1, Entrega2), Canjes),
    esValidoElCanje(Persona1, Persona2, Entrega1, Entrega2),
    haceNegocio(Persona1, Persona2, Entrega1, Entrega2),
    forall(member((OtraPersona, EntregaP1, EntregaOtraPersona), Canjes), salioGanando(Persona1, OtraPersona, EntregaP1, EntregaOtraPersona)).

/*
salioGanando(Persona, OtraPersona, Entrega, Recibe):- % No es posible inversibilidad en cuanto a "Entrega, Recibe" por las infinitas combinaciones
    member(F,Entrega),
    obtuvoFigurita(Persona, F),
    member(F2,Recibe),
    obtuvoFigurita(OtraPersona, F2),
    %esValidoElCanje(Persona, OtraPersona, Entrega, Recibe),
    nivelDeInteresTotal(Persona, Recibe, InteresDePersona), 
    nivelDeInteresTotal(OtraPersona, Entrega, InteresDelOtro),
    InteresDePersona > InteresDelOtro.
*/

salioGanando(Persona, OtraPersona, Entrega, Recibe) :-
    obtuvoFigurita(Persona, _),
    obtuvoFigurita(OtraPersona, _),
    Persona \= OtraPersona,

    findall(F, obtuvoFigurita(Persona, F), FigusP1),   %Se buscan todas las figuritas que tiene la persona1
    findall(F, obtuvoFigurita(OtraPersona, F), FigusP2), %Sebuscan todas las figuritas que tiene la persona2

    subconjuntoNoVacio(FigusP1, Entrega), %Aca, se mandan las listas de todas las figuritas de la P1, por ejemplo [2,4,5] y en entrega se recibe lo que se hace en (*)
    subconjuntoNoVacio(FigusP2, Recibe),

    %esValidoElCanje(Persona, OtraPersona, Entrega, Recibe),
    nivelDeInteresTotal(Persona, Recibe, InteresDePersona),     %(**)
    nivelDeInteresTotal(OtraPersona, Entrega, InteresDelOtro),
    InteresDePersona > InteresDelOtro.

subconjuntoNoVacio(Lista, Sub) :-   %(*) aca llega la lista de figus de la persona y se devuelve una a una, una lista con las cartas que puede canjear una persona, siguiendo el ejemplo, en cada consulta devuelve [2], luego a la siguiente [4], luego [5], luego [2,4], luego [2,5] yasi. Luego en (**) se analiza el nivelDeInteresTotal para cada uno de estos envios.
    eligeFiguritas(Lista, Sub),
    Sub \= [].   % filtro la lista vacía

eligeFiguritas([], []). %hace la recursividad hasta que las listas sean vacias
eligeFiguritas([F|Resto], [F|Elegidas]) :- eligeFiguritas(Resto, Elegidas). 
eligeFiguritas([_|Resto], Elegidas) :- eligeFiguritas(Resto, Elegidas).

/*
  eligeFiguritas(Lista, Elegidas):

  - La idea era que genere todos los posibles subconjuntos de la lista.
  - Para cada elemento de la lista original (F), pueden pasar dos cosas: 
      -Puede incluit el elemento en la lista de salida, en [F|Elegidas]
      -Puede no incluirlo: en [_|Resto]

  Por ejemplo con [1,2]:

      F = 1 por ser el primero de la lista y ahi puede pasar que:
         que lo incluya [1|...] y recurre al resto [2]
         que lo excluya, osea, resto [2] sin incluir 1

      F = 2
         - si lo incluye forma:  [1,2] o [2]
         - si no lo incluye forma:  [1] o []

  forma: 
[1,2], [1], [2]  (la lista vacía se descarta)

Igualmente esta muy feo, porque termino quedando extraño. El objetivo de esto era decir que capaz no era conveniente hacer este inversible porque hay opciones de canje como estas: 

Flor recibe= [3,7,1,5]  ---> Flor ya tiene la 7 y la 5 (es un canje valido porque podria canjear repetidas), pero tambien recibe la 3 y la 1 y juntas suman un interes de 43
Lala recibe = [5,5,7,4,2] ---->  Lala ya tiene la 7 y la 5,  pero no tiene la 4 y la 2 y juntas suman un interes de 65
Entonces, lala sale ganando porque recibe algo de interes mayor, 65 > 43 y esto sucede incluso si se intercambian figuritas que cada una ya tiene. Si es asi, deberiamos tener en cuenta este tipo de canjes para todas las personas y habria muchisimas combninaciones 
es lo que pasa al poner:  salioGanando(lala, flor, RecibeFlor, RecibeLala)
no terminas de hacer consultas en la terminal 

*/


% =========== Canjes válidos ===========

/*
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

*/


%Tenemos un enfoque demasiado procedural, intentar aprovechar más las herramientas del paradigma lógico.
