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
man(goedelS). % ehermann schmidt
man(klausS). % sohn schmidt
man(peterH).
man(toonyH).
woman(annaS). % ehefrau schmidt
woman(minaS). % tochter schmidt
woman(tinaH). 

/* married */

married_with(goedelS,annaS).
married_with(peterH,tinaH).

married(A,B) :- married_with(A,B).
married(A,B) :- married_with(B,A).


/* parent relatioship */
parent(goedelS,klausS). % klausS der Sohn von goedelS
parent(goedelS,minaS). % minaS Tocheter von goedelS
parent(annaS,klausS). % klausS der Sohn von annaS
parent(annaS,minaS). % minaS Tochter von annaS
parent(peterH,toonyH). 
parent(tinaH,toonyH).
parent(lothar,annaS).
parent(lothar,tinaH).







/* mother/father rel */
mother(X,Y):-woman(X),parent(X,Y).
father(X,Y):-man(X),parent(X,Y).

/* full sibling rel */
sibling(X,Y):-mother(Z,X),mother(Z,Y),father(Q,X),father(Q,Y),notEqual(X,Y).

/* brother from another mother :)*/
halfSibling(X,Y):-xor((mother(Z,X),mother(Z,Y)),(father(Q,X),father(Q,Y))).

/*cousin rel*/
halfCousin(X,Y):-halfSibling(Z,Q),xor((mother(Z,X),mother(Q,Y)),(father(Z,X),father(Q,Y))),notEqual(X,Y),not(sibling(X,Y)).

/* co-brother in law */
brotherInLaw(A,B):-married(A,Z),married(Y,B),
xor(halfSibling(Z,B),halfSibling(A,Y)),notEqualList([A,B,Z,Y]).










