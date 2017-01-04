% Lekikon, jeder Eintrag ist ein 5-er Tupel aus dem
% lex(Wort,Semantik,Typ,Numerus,Genus)
%

% Interrogativsatz unterscheiden wir in offene Fragen und geschlossene Fragen
% Offene Frage  in unserem Kontext ist nur Wer. Wie, Wo, etc. sind ausserhalb der KB
% Wer ist der Vater von MinaS?
% (Wie sind MinaS und GoedelS verwandt?)
%
% Geschlossene Frage sind mit Ja oder Nein zu beantworten.
% Ist goedelS der Vater von Minas?
%
% Offene Frage Woerter
lex(wer,	semantic,	fragewort,	_,	_).
lex(ist,  _,verb, singular, _).      % Ist kann auch in offenen Fragen auftachen, Wer ist der Vater von Paul?
lex(sind, _,verb, plural, _).


% geschlossene Fragen
lex(ist,	_,istFrage, singular, _).  %ist als Frage zB. Ist Paul der Vater von Achim?, Geschlossene Frage
lex(sind, _,istFrage, plural, _).

% bestimmte Artikel
lex(der,	_, bestimmterArtikel,singular,maenlich).
lex(die,	_, bestimmterArtikel,singular,weiblich).
lex(die,	_, bestimmterArtikel,plural,weiblich).


% unbestimmte Artikel
lex(ein,	_,unbestimmterArtikel,singular,maenlich).
lex(ein,	_,unbestimmterArtikel,singular,neutral). % schauen ob wir es brauchen
lex(eine,	_,unbestimmterArtikel,singular,weiblich).
lex(einen,	_,unbestimmterArtikel,singular,maenlich).

% Beziehungs-Mapper
%lex(mann,	man,	nomen,	singular,	maenlich).
%lex(frau,	woman,	nomen,	singular,	weiblich).
lex(eltern,		parent,		nomen,		plural,	weiblich).
%lex(verheiratet,	woman,	nomen,	plural,	weiblich).
lex(mutter,	mother,	nomen,	singular,	weiblich).
lex(vater,	father,	nomen,	singular,	maenlich).
lex(geschwister,	sibling,	nomen,	plural,	weiblich).
lex(halbgeschwister,	halfSibling,	nomen,	plural,	weiblich).


%%% cousin
lex(cousin,	cousin,	nomen,	singular,	maenlich).

lex(verschwaegert,	brotherInLaw,	nomen,	plural,	weiblich).

% verheiratet
lex(frau,frauVon, nomen,singular, weiblich).
lex(mann,mannVon, nomen,singular, maenlich).

%geschwister
lex(bruder,bruder, nomen,singular, maenlich).
lex(schwester,schwester, nomen,singular, weiblich).

% kinder
lex(sohn,sohn, nomen,singular, maenlich).
lex(tochter,tochter, nomen,singular, weiblich).

% Präpositionen
lex(von,	_,	praeposition,	_,	_).

% Geschlechtstest
lex(Name,	Name,	name,	singular,	maenlich) :- man(Name). %Gross geschrieben weil es ein Variable ist zum Suchen in KB
lex(Name,	Name,	name,	singular,	weiblich) :- woman(Name).

%frage([Wer,sind, die, eltern, von, minaS],[]).
%frage([Wer,sind, die, eltern, von, X],[]).
%frage([ist, goedelS, der, vater, von, X],[]).
%frage([ist, goedelS, der, vater, von, X],[]).
%
% Wer sind die Geschwister von Mina?


% ist der mann von anna der vater von mina?
% ist die tochter von goedel die schwester von klaus?
% ist der vater von mina der vater von klaus?
% ist die tochter von lothar die mutter von klaus?
% ist der sohn von goedel der cousin von toony?
% ist die mutter von mina die frau von goedel?