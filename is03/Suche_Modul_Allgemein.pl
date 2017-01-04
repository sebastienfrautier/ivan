


% Das Programm wird mit solve(depth), solve(breadth) oder solve(informed) aufgerufen.
% Holt die Startzustands Beschreibung
% Ruft solve auf mit dem Anfangszustand und der Strategy
solve(Strategy):-
  % Hole den Startzustand
  start_description(StartState),
  % Rufe Solve mit dem 3er Tupel und der Strategy auf
  solve((start,StartState,_),Strategy).



% Prädikat search:
%   1. Argument ist die Liste aller Pfade. Der aktuelle Pfad ist an erster Stelle.
%   Jeder Pfad ist als Liste von Zuständen repräsentiert, allerdings in falscher
%   Reihenfolge, d.h. der Startzustand ist an letzter Position.
%   2. Argument ist die Strategie
%   3. Argument ist der Ergebnis-Pfad.
%
solve(StartNode,Strategy) :-
  % Hole den Startzustand
  start_node(StartNode),
  % Aufruf von search mit Liste aller Pfade, Strategie und Ergebniss, hier weiteren mit Schranke
  search([[StartNode]],Strategy,Path),

  % numlist(0, 5, X).
  % X ist die Range von der Schranke

  % search([[StartNode]],Strategy,Path,X),

  % Der Pfad ist in der Falschen Reihenfolge, deswegen Reverse
  reverse(Path,Path_in_correct_order),
  % Printing
  write_solution(Path_in_correct_order).



write_solution(Path):-
  nl,write('SOLUTION:'),nl,
  write_actions(Path).

write_actions([]).

write_actions([(Action,_,_)|Rest]):-
  write('Action: '),write(Action),nl,
  write_actions(Rest).

% Abbruchbedingung: Wenn ein Zielzustand erreicht ist, wird der aktuelle Pfad an den
% dritten Parameter übertragen.
search([[FirstNode|Predecessors]|_],_,[FirstNode|Predecessors]) :-
  %Ist der letzt hinzugefugte Knoten der goal_node, falsch herum deswegen FirstNode
  goal_node(FirstNode),
  %Falls er es ist dann brich ab und printen SUCCESS mit cut !
  nl,write('SUCCESS'),nl,!.

%search([[FirstNode|Predecessors]|RestPaths],Strategy,Solution, Schranke) :-

search([[FirstNode|Predecessors]|RestPaths],Strategy,Solution) :-
  % Nachfolge-Zustände berechnen
  expand(FirstNode,Children),
  % Nachfolge-Zustände einbauen
  generate_new_paths(Children,[FirstNode|Predecessors],NewPaths),
  % Neue Pfade einsortieren, hier ist der Teil indem sich alle Suchen unterscheiden

  %insert_new_paths(Strategy,NewPaths,RestPaths,AllPaths,Schranke),

  insert_new_paths(Strategy,NewPaths,RestPaths,AllPaths),
  %
  %Rekursiver aufruf von search mit den neuen Pfaden


  %search(AllPaths,Strategy,Solution,Schranke).

  search(AllPaths,Strategy,Solution).

% * war gegebens
generate_new_paths(Children,Path,NewPaths):-
  % maplist
  maplist(get_state,Path,States),
  generate_new_paths_help(Children,Path,States,NewPaths).



% Abbruchbedingung, wenn alle Kindzustände abgearbeitet sind.
%
generate_new_paths_help([],_,_,[]).


% Falls der Kindzustand bereits im Pfad vorhanden war, wird der gesamte Pfad verworfen,
% denn er würde nur in einem Zyklus enden. (Dies betrifft nicht die Fortsetzung des
% Pfades mit Geschwister-Kindern.) Es wird nicht überprüft, ob der Kindzustand in einem
% anderen Pfad vorkommt, denn möglicherweise ist dieser Weg der günstigere. Deswegen auch das !
%
generate_new_paths_help([FirstChild|RestChildren],Path,States,RestNewPaths):-
  get_state(FirstChild,State),state_member(State,States),!,
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).


% Ansonsten, also falls der Kindzustand noch nicht im Pfad vorhanden war, wird er als
% Nachfolge-Zustand eingebaut.
%
generate_new_paths_help([FirstChild|RestChildren],Path,States,[[FirstChild|Path]|RestNewPaths]):-
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).


get_state((_,State,_),State).



%%% Strategie:
write_action([[(Action,_)|_]|_]):-
  nl,write('Action___: '),write(Action),nl.

write_next_state([[_,(_,State)|_]|_]):-
  nl,write('Go on with: '),write(State),nl.

write_state([[(_,State)|_]|_]):-
  write('New State: '),write(State),nl.

write_fail(depth,[[(_,State)|_]|_]):-
  nl,write('FAIL, go on with: '),write(State),nl.

write_fail(_,_):-  nl,write('FAIL').

% Alle Strategien: Keine neuen Pfade vorhanden
insert_new_paths(Strategy,[],OldPaths,OldPaths):-
  write_fail(Strategy,OldPaths),!.


%iterative Tiefensuche


insert_new_paths(depth_it,NewPaths,OldPaths,AllPaths, Schranke):-


  %filter auf new paths

  %largerThan(A,B) :- length(B,C), C > A.

  %filterList(A, In, Out) :-
  %    exclude(largerThan(A), In, Out).

  %filterList(Schranke, NewPaths, NewPaths1)

  append(NewPaths1,OldPaths,AllPaths),
  % alle elemente von new paths verwerfen die laenger als schranke






% Tiefensuche
insert_new_paths(depth,NewPaths,OldPaths,AllPaths):-
  % Die neuen Pfade vor die alten gehaengt, danach wird das letzt hinzugefugte Element jetzt betrachtet
  length(OldPaths, Old),
  writeln('Tiefe'),
  writeln(Old),
  append(NewPaths,OldPaths,AllPaths),
  %writeln(OldPaths),
  write_action(NewPaths).

% Breitensuche
insert_new_paths(breadth,NewPaths,OldPaths,AllPaths):-
  % Die neuen Pfade werden hinter die alten gehaengt, daher werden erst alle alten Elemente betrachtet
  append(OldPaths,NewPaths,AllPaths),
  write_next_state(AllPaths),
  write_action(AllPaths).

% Hill climbing
insert_new_paths(hill_climbing,NewPaths,_,[BestPath]):-
  % wir bewerden die neuen Pfade mit der Greedy strategy um
  eval_paths(greedy,NewPaths),
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Nur der Beste, ist der beste besser als der bisherige
  % Dazu brauchen wir das momentane Element, welches an zweiter Stelle der Liste ist
  [[_|CurrentPath]|_] = NewPaths,
  % diesen muessen wir mit einem welt initialisieren
  eval_paths(hill_climbing,[CurrentPath]),
  % insert mit einem ein elementiger liste als old paths parameter
  % da die liste aufsteigendsoriter ist nehmen wir das erste element
  insert_new_paths_informed(NewPaths,[CurrentPath],[BestPath|_]),
  write_action([BestPath]),
  write_state([BestPath]).

% Hill climbing mit Backtracking
insert_new_paths(hill_climbing_bt,NewPaths,OldPaths,AllPaths):-
  % wir bewerden die neuen Pfade mit der Greedy strategy um
  eval_paths(greedy,NewPaths),
  % Hier muessen wir ihm alle Uebergeben damit er backtracken kann
  insert_new_paths_informed(NewPaths,[],SortedPaths),
  % Backtracking, wir brauchen die SortedPaths um sie vor ranzuhaengen
  append(SortedPaths,OldPaths,AllPaths),
  write_action(SortedPaths),
  write_state(SortedPaths).

% Informierte Suche: Gierige Bestensuche
insert_new_paths(greedy,NewPaths,OldPaths,AllPaths):-
  eval_paths(greedy,NewPaths),
  insert_new_paths_informed(NewPaths,OldPaths,AllPaths),
  write_action(AllPaths),
  write_state(AllPaths).

% Informierte Suche: A
insert_new_paths(a,NewPaths,OldPaths,AllPaths):-
  eval_paths(a,NewPaths),
  %writeln('old path'),
  %writeln(OldPaths),
  %writeln('new path'),
  %writeln(CurrentPath),
  insert_new_paths_informed(NewPaths,OldPaths,AllPaths),
  write_action(AllPaths),
  write_state(AllPaths).
