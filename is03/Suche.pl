%
% Iterative Tiefensuche:
%   Eine Variable 'Suchtiefe' einführen, die nach jeder erfolglosen Suche
%   um eins erhöht wird, um die Distanz zum Start Node dar zu stellen
%   Bei insert_new_paths(depth,..., Suchtiefe,...) muss geprueft werden, ob die Schranke
%   schon erreicht wurde. Wenn ja, werden die neuen Pfade verworfen


:- consult('Suche_Modul_Allgemein.pl').
:- consult('Suche_Modul_Informierte_Suche.pl').
%%% Spezieller Teil: Planung
:- consult('Suche_Modul_Planung.pl').


% Start beschreibung mit 4 Blocken
start_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4),  %mit Block4
  block(block5),  %mit Block5
  on(table,block2),
  on(table,block3),
  on(block2,block5),
  on(table,block4), %mit Block4
  on(block5, block1),
  clear(block1),
  clear(block3),
  clear(block4), %mit Block4
  handempty
  ]).


% Ziel beschreibung mit 4 Blocken
goal_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4), %mit Block4
  on(block4,block2), %mit Block4
  on(table,block3),
  on(table,block1),
  on(block1,block4), %mit Block4
%  on(block1,block2), %ohne Block4
  clear(block3),
  clear(block2),
  handempty
  ]).



