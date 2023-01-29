start:-first,play.
first:-
write('Welcome to Pro-Wordle!'),nl,
write('----------------------'),nl,
addfact.

addfact:-
	write('Please enter a word and its category on separate lines:'),nl,
	read(X),
	(X= done, write(' Done building the words database ... '),nl;
	read(Y),
	assert(word(X,Y)),addfact).


 is_category(C):-
       	word(_,C).

categories(L):-
	setof(X,is_category(X),L).
       
available_length(L):-
	word(X,_),
	string_length(X,L),!.
	
pick_word(W,L,C):-
	word(W,C),
	string_length(W,L).


		
correct_letters(L1,L2,Cl):- 
intersection(L2,L1,[H|T]),
setof(H,intersection(L2,L1,[H|T]),Cl).

correct_positions([],[],[]).

correct_positions([],[_|_],[]).
correct_positions([_|_],[],[]).
correct_positions([H|T],[H|T2],[H|T3]):-
	correct_positions(T,T2,T3).
correct_positions([H|T],[X|T2],CL):-	
	H\=X,correct_positions(T,T2,CL).

contains(C,L,X):-setof(W,pick_word(W,L,C),X).

play:-
write('The availabe categories is :'), nl,
categories(L),
write(L),nl,
choosethecategory(L).
choosethecategory(L):-
write("Choose a category:"),nl,
read(X),
(
\+member(X,L),
write("There is no such a category :"),nl,
choosethecategory(L);

member(X,L),
thelength(X)
).
thelength(X):-
write("Choose a length"),nl,
read(Y),
(
\+pick_word(_,Y,X),
write("There are no word of this length :"),nl,
thelength(X);
pick_word(_,Y,X),
write("Game started. You have "),
N is Y+1,
write(N),
write(" Guesses"),nl, 
thegame(Y,X)
).

thegame(Thelength,Thecategory):-
contains(Thecategory,Thelength,X),
random_member(Theword,X),
N is Thelength +1 ,
theplay(Theword ,N, Thelength ).
theplay(Theword,N, Thelength):-
N>1,
write(" Enter a word composed of "),
write(Thelength),
write(" letters"),nl,
read(X),
(
 X = Theword,
 write("You win ");
 \+string_length(X,Thelength),
 write("Word is not composed of "),
 write(Thelength),
 write(" letters.Try again "),
 theplay(Theword, N, Thelength);
 string_length(X,Thelength),
 string_chars(Theword,List1),
 string_chars(X,List2),
 correct_positions(List1,List2,Thecorrectposition),
 correct_letters(List1,List2 ,Thecorrectletters),
 write(" Correct letters is "),
 write(Thecorrectletters), nl, 
 write("The correct positions is "), 
 write(Thecorrectposition), nl,
 N2 is N-1 ,write(" The remaining number of guesses is  "),
 write(N2),nl,
 theplay(Theword, N2, Thelength)
).

 
theplay(Theword, 1,Thelength):-
write(" Enter a word composed of "),
write(Thelength),
write(" letters"),nl,
read(X),
(
X = Theword,
 write("You win !"),nl;
 \+string_length(X,Thelength),
 write("Word is not composed of "),
 write(Thelength),
 write(" letters.Try again "),nl,
 theplay(Theword, 1, Thelength);
 write(" You lost !" )
).









