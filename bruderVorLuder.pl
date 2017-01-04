man(jonny).
man(buzzy).
luder(lisa).
luder(tina).

bruder(jonny,buzzy).

notEqualList(List):-
    forall(select(Item, List, Rest),
           forall(member(Item2, Rest),
                  Item \== Item2)).

bruderVorLuder(X,Y,Z):-bruder(X,Y);bruder(X,Z);bruder(Y,Z),notEqualList([X,Y,Z]).
