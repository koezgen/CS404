% Facts about people
man(gencer).
man(can).
man(rasim).

woman(beyza).
woman(canan).
woman(meryem).

person(X) :- man(X).
person(X) :- woman(X).

% Facts about bags
bag(blue).
bag(orange).
bag(red).
bag(purple).
bag(green).
bag(yellow).

% Facts about foods
food(avocado).
food(onion).
food(nuts).
food(chocolate).
food(garlic).
food(cookies).

% Helper predicates to define ownership and what food is carried
OwnsBag(Person, Bag) :- person(Person), bag(Bag).
CarriedFood(Person, Food) :- person(Person), food(Food).

OwnsYellowBag(Person) :- OwnsBag(Person, yellow).
CarriedCookies(Person) :- CarriedFood(Person, cookies).

% Clue 1: Onion was not carried with the red bag.
% Since we know from Clue 9 that Gencer carried onion, Gencer's bag is not red.
clue1(Assignments) :-
    member((gencer,onion,GencerBag), Assignments),
    GencerBag \= red.

% Clue 2: The man who owns the red bag did not carry cookies, chocolate, or avocado.
clue2(Assignments) :-
    member((Man,Food,red), Assignments),
    man(Man),
    \+ memberchk(Food,[cookies,chocolate,avocado]).

% Clue 3: Beyza owns either the yellow or blue bag and Meryem owns the other.
clue3(Assignments) :-
    member((beyza,_,BeyzaBag), Assignments),
    member((meryem,_,MeryemBag), Assignments),
    ( (BeyzaBag = yellow, MeryemBag = blue)
    ; (BeyzaBag = blue, MeryemBag = yellow) ).

% Clue 4: The avocado carrier is neither Beyza nor Gencer and does not own a blue or orange bag.
clue4(Assignments) :-
    \+ member((beyza,avocado,_), Assignments),
    \+ member((gencer,avocado,_), Assignments),
    member((Person,avocado,BagAvocado), Assignments),
    BagAvocado \= blue,
    BagAvocado \= orange.

% Clue 5: The woman who carried cookies owns the yellow bag.
clue5(Assignments) :-
    member((Woman,cookies,yellow), Assignments),
    woman(Woman).

% Clue 6: The purple bag is owned by either Can or Gencer.
clue6(Assignments) :-
    (member((can,_,purple), Assignments);
     member((gencer,_,purple), Assignments)).

% Clue 7: Chocolate was not carried with the orange bag.
clue7(Assignments) :-
    \+ member((_,chocolate,orange), Assignments).

% Clue 8: Meryem did not carry a food item with the yellow or green bag.
clue8(Assignments) :-
    member((meryem,_,MeryemBag), Assignments),
    MeryemBag \= yellow,
    MeryemBag \= green.

% Clue 9: Onion is carried by Gencer.
clue9(Assignments) :-
    member((gencer,onion,_), Assignments).

% Clue 10: Nuts were carried with the green bag and that person is guilty.
clue10(Assignments, GuiltyPerson) :-
    member((GuiltyPerson,nuts,green), Assignments).

guilty(GuiltyPerson) :-
    % The order of persons: beyza, meryem, canan, gencer, can, rasim
    Bags = [BeyzaBag, MeryemBag, CananBag, GencerBag, CanBag, RasimBag],
    Foods = [BeyzaFood, MeryemFood, CananFood, GencerFood, CanFood, RasimFood],

    permutation([blue, orange, red, purple, green, yellow], Bags),
    permutation([avocado, onion, nuts, chocolate, garlic, cookies], Foods),

    Assignments = [
        (beyza,BeyzaFood,BeyzaBag),
        (meryem,MeryemFood,MeryemBag),
        (canan,CananFood,CananBag),
        (gencer,GencerFood,GencerBag),
        (can,CanFood,CanBag),
        (rasim,RasimFood,RasimBag)
    ],

    % Apply all clues
    clue9(Assignments),
    clue3(Assignments),
    clue8(Assignments),
    clue5(Assignments),
    clue1(Assignments),
    clue2(Assignments),
    clue4(Assignments),
    clue6(Assignments),
    clue7(Assignments),
    clue10(Assignments, GuiltyPerson),

    % Print results
    format("Beyza owns the ~w bag and carried ~w.~n",[BeyzaBag,BeyzaFood]),
    format("Meryem owns the ~w bag and carried ~w.~n",[MeryemBag,MeryemFood]),
    format("Canan owns the ~w bag and carried ~w.~n",[CananBag,CananFood]),
    format("Gencer owns the ~w bag and carried ~w.~n",[GencerBag,GencerFood]),
    format("Can owns the ~w bag and carried ~w.~n",[CanBag,CanFood]),
    format("Rasim owns the ~w bag and carried ~w.~n",[RasimBag,RasimFood]),
    format("The kidnapper is: ~w~n", [GuiltyPerson]).
