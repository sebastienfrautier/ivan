% Die Schnittstelle umfasst
%   start_description   ;Beschreibung des Startzustands
%   start_node          ;Test, ob es sich um einen Startknoten handelt
%   goal_node           ;Test, ob es sich um einen Zielknoten handelt
%   state_member        ;Test, ob eine Zustandsbeschreibung in einer Liste
%                        von Zustandsbeschreibungen enthalten ist
%   expand              ;Berechnung der Kind-Zustandsbeschreibungen
%   eval-path           ;Bewertung eines Pfades


% Definition des Startknotens
start_node((start,_,_)).

% Definition des Zielknotens
% *
%wir holen uns den Ziel Zustand und ueberpruefen ob der aktuelle Zustand der Ziel Zustand ist
goal_node((_,State,_)):-
  goal_description(Goal),
  % element auf liste
  mysubset(Goal,State).
  %state_member(State,[Goal]).



% State-member
% Prueft, ob ein Zustand Teil eines anderen Zustands ist
% z.B.: "Ist der aktuelle Zustand Teil des Zielzustands?"
state_member(_,[]):- !,fail.

% *
state_member(State,[FirstState|_]):-
  mysubset(State,FirstState).

%Es ist sichergestellt, dass die beiden ersten Klauseln nicht zutreffen. *
% * "rekursiver Aufruf".
state_member(State,[_|RestStates]):-
  state_member(State,RestStates).

% Hilfskonstrukt, weil das PROLOG "subset" nicht die Unifikation von Listenelementen
% durchführt, wenn Variablen enthalten sind. "member" unifiziert hingegen.
% Ist gegeben!
mysubset([],_).

mysubset([H|T],List):-
  member(H,List),
  mysubset(T,List).

% Evaluieren eines Pfads, mit einem Suchverfahren *
% Umgebaut um die Strategie zu uebergeben
% *
eval_path(a,Suchverfahren,Path):-
  length(Path,G),
  writeln('MIT PFAD'),
  eval_state(Suchverfahren,Path,G).

eval_path(greedy,Suchverfahren,Path):-
  writeln('OHNE PFAD'),
  eval_state(Suchverfahren,Path,_).




% Die Suchverfahren
%
% Die Suchverfahren unterscheiden sich eigentlich nur
% darin, wie der Value (f(n)) berechnet wird

% A
eval_state(a,[(_,State,Value)|_],G) :-
  heuristik(right_pos,State,Heuristik),
  % Hier wird der Value auf Heuristik mit f = g + h
  Value is Heuristik + G.

% Gierige Bestensuche
eval_state(greedy,[(_,State,Heuristik)|_],_) :-
  %delegieren der heuristik an die Heuristik zum matchen
  heuristik(right_pos,State,Heuristik).

% Heuristiken

% Anzahl der Elemente des Zielmenge, die noch nicht in dem aktuellen Zustand sind
% Es es nicht A* weil nicht zulaessig, weil ueberschaetzt werden kann
% Weil wenn wir einen Stein aufheben wir uns einen
heuristik(wrong_pos,State,Value) :-
  % Wir brauchen zuerst alle Elemente der Zielmenge
  goal_description(Ziel),
  % Um welche Elemente unterscheiden sie sich
  differenzmenge(Ziel,State,Differenz),
  % Wieviele Elemente sind das?
  length(Differenz,Value).

% Zahle die Anzahl der Elemente die erfuellen
count_table(Schnitt,Pn) :-
  Pred = (member(P, Schnitt), P = (on(table,_))),
  findall(P, Pred, Ps),
  length(Ps, Pn).

count_on(Schnitt,Pn) :-
  Pred = (member(P, Schnitt), P = (on(_,_))),
  findall(P, Pred, Ps),
  length(Ps, Pn).

count_clear(Schnitt, Pn):-
  Clear = (member(P, Schnitt), P = (clear(_))),
  findall(P, Clear, Ps),
  length(Ps, Pn).

% Wir bestrafen komplizierte finale zustande die wir noch nicht haben
% wir ueberschaetzten wenn wir einen neuen komplizierte zustand dazu kriegen den wir noch nicht haben
%

heuristik(right_pos,State,Value) :-
  goal_description(Ziel),
  differenzmenge(Ziel,State,Schnitt),
  count_table(Schnitt, OnTable),
  length(Schnitt, AnzahlSchnitt),
  Value is 3*OnTable+AnzahlSchnitt.

/*
---
  Hmember = (member(P, Haben), P = (on(table,_);on(_,_))),
  findall(P, Hmember, Ps),
  length(Ps, KomplexHaben),
  writeln('komplex haben'),
  writeln(Var),
  length(Haben, EinfachHaben),
  writeln('einfach haben'),
  writeln(Var2),
  Value is EinfachHaben + KomplexHaben * 4.
---
  Clear = (member(P, Schnitt), P = (clear(_))),
  findall(P, Clear, Ps_clear),
  Count_clear = length(Ps_clear, Pn),
  Value is (Count_clear + Value),

  On = (member(P, Schnitt), P = (on(_,_))),
  findall(P, On, Ps_clear),
  Count_on = length(Ps_clear, Pn),
  Value is (Value + Count_on).



count_table(Schnitt,Pn) :-
  Pred = (member(P, Schnitt), P = (on(table,_))),
  findall(P, Pred, Ps),
  length(Ps, Pn).
*/
%count_clear(Schnitt, Pn):-
%  Clear = (member(P, Schnitt), P = (clear(_))),
%  findall(P, Clear, Ps_clear),
%  length(Ps_clear, Pn).

%count_on(Schnitt, Pn):-
%  Clear = (member(P, Schnitt), P = (on(_,_))),
%  findall(P, Clear, Ps_clear),
%  length(Ps_clear, Pn).


% Aktionen
% Waren alle schon gegeben in der Conds List Schreibweise
% Was gilt Vorher
% Was gilt danach nicht mehr
% Was gilt danach

action(pick_up(X),
       [handempty, clear(X), on(table,X)],
       [handempty, clear(X), on(table,X)],
       [holding(X)]).

action(pick_up(X),
       [handempty, clear(X), on(Y,X), block(Y)],
       [handempty, clear(X), on(Y,X)],
       [holding(X), clear(Y)]).

action(put_on_table(X),
       [holding(X)],
       [holding(X)],
       [handempty, clear(X), on(table,X)]).

action(put_on(Y,X),
       [holding(X), clear(Y)],
       [holding(X), clear(Y)],
       [handempty, clear(X), on(Y,X)]).


% CondList: Liste von Praedikaten die Vorher gelten
% DelList:
% AddList: Welche Praedikaten gelten danach
% Liefert Aktionen, die vom momentanen Zustand aus möglich sind

expand((_,State,_),Result):-
  % Eigentlich gibt Prolog nur eine Antwort, wir wollen aber alle Kinderknoten daher findall
  % War gegeben, haetten wir
  findall((Name,NewState,_),expand_help(State,Name,NewState),Result).

% *
expand_help(State,Name,NewState):-
  % Matche eine Actions
  action(Name, CondList, DelList, AddList),
  % Sind die Praedikaten aus der CondList in meinen States
  % Hier werden die Variablen gebunden mit State
  ist_teilmenge(CondList,State),
  % Entferne die Praedikaten die danach nicht mehr gelten
  differenzmenge(State,DelList,StateDel),
  % Fuege die Zustaende die danach gelten hinzu und returne die als NewState
  vereinigungsmenge(StateDel,AddList,NewState).


% Mengenoperationen
%
% differenzmenge(Menge_A, Menge_B, Differenzmenge)
differenzmenge([], _, []).
differenzmenge([Element|Tail], Menge, Rest) :-
        member(Element, Menge), !,
        differenzmenge(Tail, Menge, Rest).
differenzmenge([Head|Tail], Menge, [Head|Rest]) :-
        differenzmenge(Tail, Menge, Rest).

% vereinigungsmenge(Menge_A, Menge_B, Menge_C)
vereinigungsmenge([], Liste, Liste).
vereinigungsmenge([Head|Tail], Liste, Rest) :-
        member(Head, Liste), !,
        vereinigungsmenge(Tail, Liste, Rest).
vereinigungsmenge([Head|Tail], Liste, [Head|Rest]) :-
        vereinigungsmenge(Tail, Liste, Rest).

% ist_teilmenge(Teilmenge, Menge)
ist_teilmenge([], _).
ist_teilmenge([Element|Rest], Menge) :-
        member(Element, Menge),
        ist_teilmenge(Rest, Menge).

% schnittmenge(Menge_A, Menge_B, Menge_C)
schnittmenge([], _, []).
schnittmenge([Element|Tail], Liste, Schnitt) :-
        member(Element, Liste), !,
        Schnitt = [Element|Rest],
        schnittmenge(Tail, Liste, Rest).
schnittmenge([_|Tail], Liste, Rest) :-
        schnittmenge(Tail, Liste, Rest).

% schnitt menge der elemente die auf
schnittmenge_on_table([], _, []).
schnittmenge_on_table([Element|Tail], Liste, Schnitt) :-
        member(Element, Liste), !,
        Schnitt = [Element|Rest],
        schnittmenge(Tail, Liste, Rest).
schnittmenge_on([_|Tail], Liste, Rest) :-
        schnittmenge(Tail, Liste, Rest).