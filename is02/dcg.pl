:- ensure_loaded([dictionary]).
:- ensure_loaded([readsentence]).


/*helper*/
and(A,B) :- A,B.
or(A,B) :- A;B.
nand(A,B) :- not(and(A,B)).
xor(A,B) :- or(A,B),nand(A,B).
notEqual(A,B):- A\=B.
notEqualList(List):-
    forall(select(Item, List, Rest),
           forall(member(Item2, Rest),
                  Item \== Item2)).


/* the beginning of all things*/
man(lothar).

/* sex unification */
man(goedel). % ehermann schmidt
man(klaus). % sohn schmidt
man(peter).
man(toony).
woman(anna). % ehefrau schmidt
woman(mina). % tochter schmidt
woman(tina).

/* married */

married_with(goedel,anna).
married_with(peter,tina).

married(A,B) :- married_with(A,B).
married(A,B) :- married_with(B,A).


/* parent relatioship */
parent(goedel,klaus). % klausS der Sohn von goedelS
parent(goedel,mina). % minaS Tocheter von goedelS
parent(anna,klaus). % klausS der Sohn von annaS
parent(anna,mina). % minaS Tochter von annaS
parent(peter,toony).
parent(tina,toony).
parent(lothar,anna).
parent(lothar,tina).



/* mother/father rel */
mother(X,Y):-woman(X),parent(X,Y).
father(X,Y):-man(X),parent(X,Y).

/* verheiratet */
frauVon(X,Y):- woman(X), married(X,Y).
mannVon(X,Y):- man(X), married(X,Y).

% geschwister
bruder(X,Y):- man(X), sibling(X,Y).
schwester(X,Y):- woman(X), sibling(X,Y).

% kinder
tochter(X,Y):- woman(X), parent(Y,X).
sohn(X,Y):- man(X), parent(Y,X).

% cousin


/* full sibling rel */
sibling(X,Y):-mother(Z,X),mother(Z,Y),father(Q,X),father(Q,Y),notEqual(X,Y).

/* brother from another mother :)*/
halfSibling(X,Y):-xor((mother(Z,X),mother(Z,Y)),(father(Q,X),father(Q,Y))).

/*cousin rel*/
cousin(X,Y):-halfSibling(Z,Q),xor((mother(Z,X),mother(Q,Y)),(father(Z,X),father(Q,Y))),notEqual(X,Y),not(sibling(X,Y)).

/* co-brother in law */
brotherInLaw(A,B):-married(A,Z),married(Y,B),
xor(halfSibling(Z,B),halfSibling(A,Y)),notEqualList([A,B,Z,Y]).


/* Natuerliche Sprach Verabeitung */
verbalPhrase --> verb.
verbalPhrase --> verb,nominalPhrase.


% nominal phrase
% Eine Nominalphrase kann sein:
%   Eigenname
%   Artikel, Nomen
%   Artikel, Nomen, Präpositionalphrase

% antwort phrase
% nominal phrase ->
% nominal phrase
nominalPhrase(NUMERUS,GESCHLECHT,Name) --> name(NUMERUS,GESCHLECHT,Name).
nominalPhrase(NUMERUS,GESCHLECHT,Semantik) --> beziehung(NUMERUS,GESCHLECHT,Semantik).

%beziehung(NUMERUS,GESCHLECHT,Semantik) --> artikel(NUMERUS,GESCHLECHT),nomen(NUMERUS,GESCHLECHT,Semantik).

beziehung(NUMERUS,GESCHLECHT,[Semantik,Name]) --> artikel(NUMERUS,GESCHLECHT),nomen(NUMERUS,GESCHLECHT,Semantik),
													pp(Name).

pp(Name) --> praeposition, nominalPhrase(_,_,Name).


% Jeder Frage faellt in eine von zwei Kategorien, offene oder geschlossene Frage
/*	Fragen  */
frage --> offeneFrage(Sem).
frage --> geschlosseneFrage(Sem).

% Eine offene Frage beginnt mit einem Fragewort, gefolgt von einem Verb und einer Beziehung
% Wer sind die Eltern von MinaS?
% univ operator
% Sind ist nur ein Verb kein Fragewort, daher kein Sind Paul und Paula die eltern von Mina?
% ?- likes(mary, pizza) =.. List.
% List = [likes, mary, pizza].

offeneFrage(Sem) --> fragewort(N,G),verb(N,G),
					beziehung(N,G,[Rel,Name2]), {
  %writeln(Rel),
	Ques =.. [Rel,Wer,Name2],Ques, %zusammenbauen und gleich aufrufen
	write('Es ist '),
  writeln(Wer),
	fail
}.


geschlosseneFrage(Ques) -->
    istFrage(N,G),
    %beziung geht auch
    nominalPhrase(N,G,[Rel1, Name1]),
    beziehung(N,G,[Rel2,Name2]),
    % ist der vater von mina der vater von klaus?
    % ist fragewort
    % np = nominalPhrase mit einer geschachtelten
    %
    {
      Ques1 =..[Rel1,X,Name1],
      Ques2 =..[Rel2,X,Name2],
      %writeln([Ques1,Ques2]),
      Ques1,
      Ques2
    }.

geschlosseneFrage(Ques) -->
		istFrage(N,G),
		name(N,G,Name1),
		beziehung(N,G,[Rel,Name2]),
		{Ques =..[Rel,Name1,Name2],Ques,writeln('Ja.')}.

% Artikel
artikel(NUMERUS,GESCHLECHT) --> bestimmterArtikel(NUMERUS,GESCHLECHT).
artikel(NUMERUS,GESCHLECHT) --> unbestimmterArtikel(NUMERUS,GESCHLECHT).

/*  Lexikon */
verb(NUMERUS,GESCHLECHT) --> [X], {lex(X,	_,	verb, NUMERUS,	GESCHLECHT)}.
istFrage(NUMERUS,GESCHLECHT) --> [X],	{lex(	X,	_,	istFrage,	NUMERUS,	GESCHLECHT)}.
nomen(NUMERUS,GESCHLECHT,Semantik) --> [X], {lex( X, Semantik,	nomen,	NUMERUS,	GESCHLECHT )}.
praeposition --> [X],{lex(X,	_,	praeposition,	_,	_)}.
name(NUMERUS,GESCHLECHT,Semantik) --> [X],{lex(X,	Semantik,	name,	NUMERUS,	GESCHLECHT)}.
bestimmterArtikel(NUMERUS,GESCHLECHT) --> [X],	{lex(	X,	_,	bestimmterArtikel,	NUMERUS,	GESCHLECHT)}.
unbestimmterArtikel(NUMERUS,GESCHLECHT) --> [X],	{lex(	X,	_,	unbestimmterArtikel,	NUMERUS,	GESCHLECHT)}.
fragewort(NUMERUS,GESCHLECHT) --> [X],	{lex(	X,	_,	fragewort,	NUMERUS,	GESCHLECHT)}.

%% read sentence anbindung
fragestunde :- read_sentence(In), without_last(In, Q), frage(Q,[]).
without_last([_],[]).
without_last([X|Xs], [X|WithoutLast]) :- without_last(Xs, WithoutLast).
frage_stellen(Input) :- frage(Input,[]).




