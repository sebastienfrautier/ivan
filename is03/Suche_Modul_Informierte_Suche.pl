% Informierte Suche

% Falls die Restlichen Pfade leer sind muss nichts gemacht werden
eval_paths(_,[]).

% Wenn wir noch Pfade zum bewerten haben
eval_paths(Suchverfahren,[FirstPath|RestPaths]):-
  % Rufe eval_path() mit dem Suchverfahren und einem Pfad auf
  eval_path(Suchverfahren,Suchverfahren,FirstPath),
  % Rufe rekursive an allen anderen Pfaden eval_paths auf
  eval_paths(Suchverfahren,RestPaths).

% Es gibt keinen neuen Pfad, gibt einfach den Alten Pfad zurueck
insert_new_paths_informed([],OldPaths,OldPaths).

% Es gibt noch Elemente die wir evaluieren muessen
insert_new_paths_informed([FirstNewPath|RestNewPaths],OldPaths,AllPaths):-
  %
  insert_path_informed(FirstNewPath,OldPaths,FirstInserted),
  % Rekursiver Aufruf mit den Restlichen Elementen
  insert_new_paths_informed(RestNewPaths,FirstInserted,AllPaths).

% Wenn die Liste der alten Pfade leer ist, gibt das Aktuelle Element als Liste wieder
insert_path_informed(NewPath,[],[NewPath]).

% Wenn der Pfad billiger ist, dann wird er vorn angefügt. Die alten Pfade sind ja sortiert.)
insert_path_informed(NewPath,[FirstPath|RestPaths],[NewPath,FirstPath|RestPaths]):-
  cheaper(NewPath,FirstPath),!.

% Wenn er nicht billiger ist, wird er in den Rest einsortiert und der Kopf
% der Openliste bleibt Kopf der neuen Liste
insert_path_informed(NewPath,[FirstPath|RestPaths],[FirstPath|NewRestPaths]):-
  insert_path_informed(NewPath,RestPaths,NewRestPaths).

% Wer ist guenstiger?
cheaper([(_,_,V1)|_],[(_,_,V2)|_]):-
  V1 =< V2.


