:- set_prolog_stack(global, limit(100 000 000 000 000 000)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Defines the 52 cards in a deck
deck([	[ace,heart],[ace,diamond],[ace,club],[ace,spade],
	[2,heart],[2,diamond],[2,club],[2,spade],
	[3,heart],[3,diamond],[3,club],[3,spade],
	[4,heart],[4,diamond],[4,club],[4,spade],
	[5,heart],[5,diamond],[5,club],[5,spade],
	[6,heart],[6,diamond],[6,club],[6,spade],
	[7,heart],[7,diamond],[7,club],[7,spade],
	[8,heart],[8,diamond],[8,club],[8,spade],
	[9,heart],[9,diamond],[9,club],[9,spade],
	[10,heart],[10,diamond],[10,club],[10,spade],
	[jack,heart],[jack,diamond],[jack,club],[jack,spade],
	[queen,heart],[queen,diamond],[queen,club],[queen,spade],
	[king,heart],[king,diamond],[king,club],[king,spade]
        ]).

%% Pull 5 cards from the deck and put them into the players hand
setHand(X1, X2) :-
	deck(Cards),							%% Create the deck
	%%write('Original Deck'), nl,			%% Print the deck to console, for debugging
	%%print(Cards), nl, 						
	random_permutation(Cards, Deck),		%% Shuffle the "Cards" deck and set the new deck to "Deck"
	%%write('Shuffled Deck'), nl,			%% Print the deck to console, for debugging
	%%print(Deck), nl, 
	random_select(Card,Deck,Deck1),			%% Pick 5 random cards from the deck
	random_select(Card1,Deck1,Deck2),
	random_select(Card2,Deck2,Deck3),
	random_select(Card3,Deck3,Deck4),
	random_select(Card4,Deck4,Deck5),
	
	%%
	random_select(Card5,Deck5,Deck6),
	random_select(Card6,Deck6,Deck7),
	random_select(Card7,Deck7,Deck8),
	random_select(Card8,Deck8,Deck9),
	random_select(Card9,Deck9,Deck10),
	X1 = [Card, Card1, Card2, Card3, Card4],
	X2 = [Card5, Card6, Card7, Card8, Card9].				%% Add the cards to the players hand


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Convert between an atom and a list of character codes
convertCodes(Codes, Result) :-
    atom_codes(Result, Codes).

%% Read the next line from the input and unify the content as a list of character codes
streamCodes(Input, NextLine) :-
    read_line_to_codes(Input, Line),			%% read next line and convert to char codes
    (   Line == end_of_file						%% If the current line is blank then set next line to empty
    ->  NextLine = []
    ;   convertCodes(Line, LastLine),			%% Otherwise convert the char codes
        NextLine = [LastLine | FurtherLines],	%% Read the next input line
        streamCodes(Input, FurtherLines) ).		%% and recursively call the stream

%% Starter function for the read
readFromFile(NextLine) :-
	open('A2card3log.txt', read, Input),		%% Open the input stream
    streamCodes(Input, NextLine),				%% Start processing the input
    close(Input).								%% Close the input stream


readFromFile2(NextLine) :-
	open('A2card3logPlayer2.txt', read, Input),		%% Open the input stream
    streamCodes(Input, NextLine),					%% Start processing the input
    close(Input).									%% Close the input stream
	
%%Read from the winnings of Player 1
readFromFile3(NextLine) :-
	open('A2card3WinnerLog_P1.txt', read, Input),	%% Open the input stream
    streamCodes(Input, NextLine),					%% Start processing the input
    close(Input).									%% Close the input stream

readFromFile4(NextLine) :-
	open('A2card3P1_Winnings.txt', read, Input),	%% Open the input stream
    streamCodes(Input, NextLine),					%% Start processing the input
    close(Input).									%% Close the input stream
    
%%List of every hand P1 had in total

readFromFile5(NextLine) :-
	open('A2card3P1_All_Hands.txt', read, Input),	%% Open the input stream
    streamCodes(Input, NextLine),					%% Start processing the input
    close(Input).

readFromFile6(NextLine) :-
	open('A2predictLog.txt', read, Input),	%% Open the input stream
    streamCodes(Input, NextLine),					%% Start processing the input
    close(Input).

readFromFile7(NextLine) :-
	open('A2winLog.txt', read, Input),	%% Open the input stream
    streamCodes(Input, NextLine),					%% Start processing the input
    close(Input).

/*

1 pair = P1
2 high_card

3 royal flush = P1
4 pair

5 3 of kind
6 pair

odd  = P1
even = P2

P1 = [a,b,c]
P2 = [x,y,z]

assignToTable[ a vs. x, b vs. y, c vs. z ]


*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Overwrites the Out file in one already exists
writeToFile(Sol, Out) :-
	open(Out, write, OutS),
	close(OutS).

%% Write data to output file, code modified from Dr. Mins hints,
solution(Solutions, OutputFile) :-
	open(OutputFile, append, OutStream),
	write(OutStream, Solutions), nl(OutStream),
	close(OutStream).
	
solution2(Solutions, OutputFile) :-
	open(OutputFile, append, OutStream),
	write(OutStream, Solutions), nl(OutStream),
	close(OutStream).
	
winnerLog(Solutions, OutputFile) :-
	open(OutputFile, append, OutStream),
	write(OutStream, Solutions),
	close(OutStream).
	
winnerLog_nl(OutputFile) :-
	open(OutputFile, append, OutStream),
	nl(OutStream),
	close(OutStream).

player1Log(Solutions, OutputFile) :-
	open(OutputFile, append, OutStream),
	write(OutStream, Solutions), nl(OutStream),
	close(OutStream).




%% Function to print the probability to the console
printStats(CardName, Freq, Prob) :-
	format('~w ~d, ~2f~n', [CardName, Freq, Prob]).
	
printStats2(CardName, Freq) :-
	format('~w ~d, ~n', [CardName, Freq]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Auxillary function that recursively counts the occurances of the rank in a file
countRank(A,[],0).						%% Recursion exit condition
countRank(A,[A|Tail],N) :-				%% Occurance has been found, increment the accumulator
	countRank(A,Tail,N2), N is 1+N2.
countRank(A,[X|Tail],N) :-				%% No occurance has been found, go to next term
	countRank(A,Tail,N2), N is N2.
	
countPred(A,B,[],[],0).
countPred(A,B,[A|Tail],[B|Tail2],N) :-
	countPred(A,B,Tail,Tail2,N2), N is 1+N2.
countPred(A,B,[J|Tail],[K|Tail2],N) :-	
	countPred(A,B,Tail,Tail2,N2), N is N2.

countPred(A,B,C,[],[],[],0).
countPred(A,B,C,[A|Tail],[B|Tail2],[C|Tail3],N) :-
	countPred(A,B,C,Tail,Tail2,Tail3,N2), N is 1+N2.
countPred(A,B,C,[J|Tail],[K|Tail2],[L|Tail3],N) :-	
	countPred(A,B,C,Tail,Tail2,Tail3,N2), N is N2.


rankPrecision(Rank, Content, PredList, WinList, Num) :-
	%%writeln(PredList), writeln(WinList),
	countPred(Rank, win, win, Content, PredList, WinList, TP),
	countPred(Rank, loss, loss, Content, PredList, WinList, TN),
	TPTN is TP + TN,
	calcProb(TPTN, Num, Precision),
	format('~w = TP: ~d TN: ~d Precision: ~5f~n', [Rank, TP, TN, Precision]).

%% Repeats card hand dealing and rank evaluation Num times
runLoop(0, Num) :-										%% If loop is at 0 then stop its execution
	readFromFile(Content),										%% Read all the output form the file
	countRank(high_card, Content, NumHighCards),				%% Count how many times each rank appeared in the runs
	countRank(pair, Content, NumPairCards),
	countRank(flush, Content, NumFlushCards),
	countRank(straight, Content, NumStraightCards),
	countRank(three_of_a_kind, Content, NumThreeCards),
	countRank(straight_flush, Content, NumSFCards),
	%% New Stuff
	countRank(royal_flush, Content, NumRFCards),
	countRank(four_of_a_kind, Content, NumFourKindCards),
	countRank(full_house, Content, NumFHCards),
	countRank(two_pair, Content, NumTwoPairCards),
	%%
	HighCardTest is NumHighCards / Num * 100,					%% Calculate the probability for each rank
	PairTest is 	NumPairCards / Num * 100,
	FlushTest is	NumFlushCards / Num * 100,
	StraightTest is NumStraightCards / Num * 100,
	ThreeTest is 	NumThreeCards / Num * 100,
	SFTest is 		NumSFCards / Num * 100,
	%% New Stuff
	RFTest is 		NumRFCards / Num * 100,
	FourKindTest is NumFourKindCards / Num * 100,
	FHTest is 		NumFHCards / Num * 100,
	TwoPairTest	is	NumTwoPairCards / Num * 100,
	%%
	print('Card frequency and probability'), writeln(''),		%% Print the probabilities to the console
	printStats('Straight Flush:', NumSFCards, SFTest),
	printStats('Three of a kind:', NumThreeCards, ThreeTest),
	printStats('Straight:', NumStraightCards, StraightTest),
	printStats('Flush:', NumFlushCards, FlushTest),
	printStats('Pair:', NumPairCards, PairTest),
	printStats('High Card:', NumHighCards, HighCardTest),
	%% New Stuff
	printStats('Royal Flush Card:', NumRFCards, RFTest),
	printStats('Four of a kind Card:', NumFourKindCards, FourKindTest),
	printStats('Full House Card:', NumFHCards, FHTest),
	printStats('TwoPair Card:', NumTwoPairCards, TwoPairTest),
	
	%%%%%% COUNTING THE WINNINGS OF PLAYER 1 FROM THE A2card3P1_Winnings.txt %%%%%%
	
	readFromFile5(Content4),				
	countRank(high_card, Content4, NumHighCards4),		
	countRank(pair, Content4, NumPairCards4),
	countRank(flush, Content4, NumFlushCards4),
	countRank(straight, Content4, NumStraightCards4),
	countRank(three_of_a_kind, Content4, NumThreeCards4),
	countRank(straight_flush, Content4, NumSFCards4),
	
	countRank(royal_flush, Content4, NumRFCards4),
	countRank(four_of_a_kind, Content4, NumFourKindCards4),
	countRank(full_house, Content4, NumFHCards4),
	countRank(two_pair, Content4, NumTwoPairCards4),

	readFromFile4(Content5),				
	countRank(high_card, Content5, WinHighCards5),		
	countRank(pair, Content5, WinPairCards5),
	countRank(flush, Content5, WinFlushCards5),
	countRank(straight, Content5, WinStraightCards5),
	countRank(three_of_a_kind, Content5, WinThreeCards5),
	countRank(straight_flush, Content5, WinSFCards5),
	countRank(royal_flush, Content5, WinRFCards5),
	countRank(four_of_a_kind, Content5, WinFourKindCards5),
	countRank(full_house, Content5, WinFHCards5),
	countRank(two_pair, Content5, WinTwoPairCards5),

    calcProb(WinHighCards5, NumHighCards4, HighCardTest4),
    calcProb(WinPairCards5, NumPairCards4, PairTest4),
    calcProb(WinFlushCards5, NumFlushCards4, FlushTest4),
    calcProb(WinStraightCards5, NumStraightCards4, StraightTest4),
    calcProb(WinThreeCards5, NumThreeCards4, ThreeTest4),
    
    calcProb(WinSFCards5, NumSFCards4, SFTest4),
    calcProb(WinRFCards5, NumRFCards4, RFTest4),
    calcProb(WinFourKindCards5, NumFourKindCards4, FourKindTest4),
    calcProb(WinFHCards5, NumFHCards4, FHTest4),
    calcProb(WinTwoPairCards5, NumTwoPairCards4, TwoPairTest4),
	
	
	print('WINNINGS OF PLAYER 1'), writeln(''),		%% Print the probabilities to the console
	printStats('Royal Flush Card Victories:    ', WinRFCards5, RFTest4),
	printStats('Straight Flush Victories:      ', WinSFCards5, SFTest4),
	printStats('Four of a kind Card Victories: ', WinFourKindCards5, FourKindTest4),
	printStats('Full House Card Victories:     ', WinFHCards5, FHTest4),
	printStats('Flush Victories:               ', WinFlushCards5, FlushTest4),
	printStats('Straight Victories:            ', WinStraightCards5, StraightTest4),
	printStats('Three of a kind Victories:     ', WinThreeCards5, ThreeTest4),
	printStats('TwoPair Card Victories:        ', WinTwoPairCards5, TwoPairTest4),
	printStats('Pair Victories:                ', WinPairCards5, PairTest4),
	printStats('High Card Victories:           ', WinHighCards5, HighCardTest4),
	
	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FOR PLAYER 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%
	player1Log(Num, 'A2card3P1_All_Hands.txt'),
	readFromFile2(Content2),											%% Read all the output form the file
	countRank(high_card, Content2, NumHighCards2),						%% Count how many times each rank appeared in the runs
	countRank(pair, Content2, NumPairCards2),
	countRank(flush, Content2, NumFlushCards2),
	countRank(straight, Content2, NumStraightCards2),
	countRank(three_of_a_kind, Content2, NumThreeCards2),
	countRank(straight_flush, Content2, NumSFCards2),
	%% New Stuff
	countRank(royal_flush, Content2, NumRFCards2),
	countRank(four_of_a_kind, Content2, NumFourKindCards2),
	countRank(full_house, Content2, NumFHCards2),
	countRank(two_pair, Content2, NumTwoPairCards2),
	%%
	HighCardTest2 is NumHighCards2 / Num * 100,								%% Calculate the probability for each rank
	PairTest2 is 	NumPairCards2 / Num * 100,
	FlushTest2 is	NumFlushCards2 / Num * 100,
	StraightTest2 is NumStraightCards2 / Num * 100,
	ThreeTest2 is 	NumThreeCards2 / Num * 100,
	SFTest2 is 		NumSFCards2 / Num * 100,
	%% New Stuff
	RFTest2 is 		NumRFCards2 / Num * 100,
	FourKindTest2 is NumFourKindCards2 / Num * 100,
	FHTest2 is 		NumFHCards2 / Num * 100,
	TwoPairTest2	is	NumTwoPairCards2 / Num * 100,
	%%
	print('Card frequency and probability for Player 2'), writeln(''),		%% Print the probabilities to the console
	printStats('Straight Flush Play 2:      ', NumSFCards2, SFTest2),
	printStats('Three of a kind Play 2:     ', NumThreeCards2, ThreeTest2),
	printStats('Straight Play 2:            ', NumStraightCards2, StraightTest2),
	printStats('Flush Play 2:               ', NumFlushCards2, FlushTest2),
	printStats('Pair Play 2:                ', NumPairCards2, PairTest2),
	printStats('High Card Play 2:           ', NumHighCards2, HighCardTest2),
	%% New Stuff
	printStats('Royal Flush Card Play 2:    ', NumRFCards2, RFTest2),
	printStats('Four of a kind Card Play 2: ', NumFourKindCards2, FourKindTest2),
	printStats('Full House Card Play 2:     ', NumFHCards2, FHTest2),
	printStats('TwoPair Card Play 2:        ', NumTwoPairCards2, TwoPairTest2),
	
	%%%%%% COUNTING THE PLAYS OF BOTH PLAYERS FOR TABLE 3-1 A2card3WinnerLog_P1.txt %%%%%%
	
	readFromFile3(Content3),
	countRank(high_cardroyal_flush, Content3, T1),
	countRank(high_cardstraight_flush, Content3, T2),
	countRank(high_cardfour_of_a_kind, Content3,   T3),
	countRank(high_cardfull_house, Content3,   T4),
	countRank(high_cardflush, Content3,   T5),
	countRank(high_cardstraight, Content3,  T6 ),
	countRank(high_cardthree_of_a_kind, Content3, T7),
	countRank(high_cardtwo_pair, Content3,  T8 ),
	countRank(high_cardpair, Content3,  T9),
	countRank(high_cardhigh_card, Content3, T10),

	countRank(pairroyal_flush, Content3,   T11 ),
	countRank(pairstraight_flush, Content3,   T12 ),
	countRank(pairfour_of_a_kind, Content3,    T13),
	countRank(pairfull_house, Content3,   T14 ),
	countRank(pairflush, Content3,   T15 ),
	countRank(pairstraight, Content3,  T16  ),
	countRank(pairthree_of_a_kind, Content3, T17),
	countRank(pairtwo_pair, Content3,   T18 ),
	countRank(pairpair, Content3, T19),
	countRank(pairhigh_card, Content3, T20),
		
	countRank(two_pairroyal_flush, Content3, T21),
	countRank(two_pairstraight_flush, Content3, T22),
	countRank(two_pairfour_of_a_kind, Content3, T23),
	countRank(two_pairfull_house, Content3, T24),
	countRank(two_pairflush, Content3, T25),
	countRank(two_pairstraight, Content3, T26),
	countRank(two_pairthree_of_a_kind, Content3, T27),
	countRank(two_pairtwo_pair, Content3, T28),
	countRank(two_pairpair, Content3, T29),
	countRank(two_pairhigh_card, Content3, T30),
		
	countRank(three_of_a_kindroyal_flush, Content3, T31),
	countRank(three_of_a_kindstraight_flush, Content3, T32),
	countRank(three_of_a_kindfour_of_a_kind, Content3, T33),
	countRank(three_of_a_kindfull_house, Content3, T34),
	countRank(three_of_a_kindflush, Content3, T35),
	countRank(three_of_a_kindstraight, Content3, T36),
	countRank(three_of_a_kindthree_of_a_kind, Content3, T37),
	countRank(three_of_a_kindtwo_pair, Content3, T38),
	countRank(three_of_a_kindpair, Content3, T39),
	countRank(three_of_a_kindhigh_card, Content3, T40),

	countRank(straightroyal_flush, Content3, T41),
	countRank(straightstraight_flush, Content3, T42),
	countRank(straightfour_of_a_kind, Content3, T43),
	countRank(straightfull_house, Content3, T44),
	countRank(straightflush, Content3, T45),
	countRank(straightstraight, Content3, T46),
	countRank(straightthree_of_a_kind, Content3, T47),
	countRank(straighttwo_pair, Content3, T48),
	countRank(straightpair, Content3, T49),
	countRank(straighthigh_card, Content3, T50),


	countRank(flushroyal_flush, Content3, T51),
	countRank(flushstraight_flush, Content3, T52),
	countRank(flushfour_of_a_kind, Content3, T53),
	countRank(flushfull_house, Content3, T54),
	countRank(flushflush, Content3, T55),
	countRank(flushstraight, Content3, T56),
	countRank(flushthree_of_a_kind, Content3, T57),
	countRank(flushtwo_pair, Content3, T58),
	countRank(flushpair, Content3, T59),
	countRank(flushhigh_card, Content3, T60),
		
	countRank(full_houseroyal_flush, Content3, T61),
	countRank(full_housestraight_flush, Content3, T62),
	countRank(full_housefour_of_a_kind, Content3, T63),
	countRank(full_housefull_house, Content3, T64),
	countRank(full_houseflush, Content3, T65),
	countRank(full_housestraight, Content3, T66),
	countRank(full_housethree_of_a_kind, Content3, T67),
	countRank(full_housetwo_pair, Content3, T68),
	countRank(full_housepair, Content3, T69),
	countRank(full_househigh_card, Content3, T70),


	countRank(four_of_a_kindroyal_flush, Content3, T71),
	countRank(four_of_a_kindstraight_flush, Content3, T72),
	countRank(four_of_a_kindfour_of_a_kind, Content3, T73),
	countRank(four_of_a_kindfull_house, Content3, T74),
	countRank(four_of_a_kindflush, Content3, T75),
	countRank(four_of_a_kindstraight, Content3, T76),
	countRank(four_of_a_kindthree_of_a_kind, Content3, T77),
	countRank(four_of_a_kindtwo_pair, Content3, T78),
	countRank(four_of_a_kindpair, Content3, T79),
	countRank(four_of_a_kindhigh_card, Content3, T80),
		
	countRank(straight_flushroyal_flush, Content3, T81),
	countRank(straight_flushstraight_flush, Content3, T82),
	countRank(straight_flushfour_of_a_kind, Content3, T83),
	countRank(straight_flushfull_house, Content3, T84),
	countRank(straight_flushflush, Content3, T85),
	countRank(straight_flushstraight, Content3, T86),
	countRank(straight_flushthree_of_a_kind, Content3, T87),
	countRank(straight_flushtwo_pair, Content3, T88),
	countRank(straight_flushpair, Content3, T89),
	countRank(straight_flushhigh_card, Content3, T90),


	countRank(royal_flushroyal_flush, Content3, T91),
	countRank(royal_flushstraight_flush, Content3, T92),
	countRank(royal_flushfour_of_a_kind, Content3, T93),
	countRank(royal_flushfull_house, Content3, T94),
	countRank(royal_flushflush, Content3, T95),
	countRank(royal_flushstraight, Content3, T96),
	countRank(royal_flushthree_of_a_kind, Content3, T97),
	countRank(royal_flushtwo_pair, Content3, T98),
	countRank(royal_flushpair, Content3, T99),
	countRank(royal_flushhigh_card, Content3, T100),

	printStats2('1, 1: ', T1),
	printStats2('1, 2: ', T2),
	printStats2('1, 3: ', T3),
	printStats2('1, 4: ', T4),
	printStats2('1, 5: ', T5),
	printStats2('1, 6: ', T6),
	printStats2('1, 7: ', T7),
	printStats2('1, 8: ', T8),
	printStats2('1, 9: ', T9),
	printStats2('1, 10: ', T10),
	printStats2('2, 1: ', T11),
	printStats2('2, 2: ', T12),
	printStats2('2, 3: ', T13),
	printStats2('2, 4: ', T14),
	printStats2('2, 5: ', T15),
	printStats2('2, 6: ', T16),
	printStats2('2, 7: ', T17),
	printStats2('2, 8: ', T18),
	printStats2('2, 9: ', T19),
	printStats2('2, 10: ', T20),
	printStats2('3, 1: ', T21),
	printStats2('3, 2: ', T22),
	printStats2('3, 3: ', T23),
	printStats2('3, 4: ', T24),
	printStats2('3, 5: ', T25),
	printStats2('3, 6: ', T26),
	printStats2('3, 7: ', T27),
	printStats2('3, 8: ', T28),
	printStats2('3, 9: ', T29),
	printStats2('3, 10: ', T30),
	printStats2('4, 1: ', T31),
	printStats2('4, 2: ', T32),
	printStats2('4, 3: ', T33),
	printStats2('4, 4: ', T34),
	printStats2('4, 5: ', T35),
	printStats2('4, 6: ', T36),
	printStats2('4, 7: ', T37),
	printStats2('4, 8: ', T38),
	printStats2('4, 9: ', T39),
	printStats2('4, 10: ', T40),
	printStats2('5, 1: ', T41),
	printStats2('5, 2: ', T42),
	printStats2('5, 3: ', T43),
	printStats2('5, 4: ', T44),
	printStats2('5, 5: ', T45),
	printStats2('5, 6: ', T46),
	printStats2('5, 7: ', T47),
	printStats2('5, 8: ', T48),
	printStats2('5, 9: ', T49),
	printStats2('5, 10: ', T50),
	printStats2('6, 1: ', T51),
	printStats2('6, 2: ', T52),
	printStats2('6, 3: ', T53),
	printStats2('6, 4: ', T54),
	printStats2('6, 5: ', T55),
	printStats2('6, 6: ', T56),
	printStats2('6, 7: ', T57),
	printStats2('6, 8: ', T58),
	printStats2('6, 9: ', T59),
	printStats2('6, 10: ', T60),
	printStats2('7, 1: ', T61),
	printStats2('7, 2: ', T62),
	printStats2('7, 3: ', T63),
	printStats2('7, 4: ', T64),
	printStats2('7, 5: ', T65),
	printStats2('7, 6: ', T66),
	printStats2('7, 7: ', T67),
	printStats2('7, 8: ', T68),
	printStats2('7, 9: ', T69),
	printStats2('7, 10: ', T70),
	printStats2('8, 1: ', T71),
	printStats2('8, 2: ', T72),
	printStats2('8, 3: ', T73),
	printStats2('8, 4: ', T74),
	printStats2('8, 5: ', T75),
	printStats2('8, 6: ', T76),
	printStats2('8, 7: ', T77),
	printStats2('8, 8: ', T78),
	printStats2('8, 9: ', T79),
	printStats2('8, 10: ',T80),
	printStats2('9, 1: ', T81),
	printStats2('9, 2: ', T82),
	printStats2('9, 3: ', T83),
	printStats2('9, 4: ', T84),
	printStats2('9, 5: ', T85),
	printStats2('9, 6: ', T86),
	printStats2('9, 7: ', T87),
	printStats2('9, 8: ', T88),
	printStats2('9, 9: ', T89),
	printStats2('9, 10: ', T90),
	printStats2('10, 	1: ', T91),
	printStats2('10, 	2: ', T92),
	printStats2('10, 	3: ', T93),
	printStats2('10, 	4: ', T94),
	printStats2('10, 	5: ', T95),
	printStats2('10, 	6: ', T96),
	printStats2('10, 	7: ', T97),
	printStats2('10, 	8: ', T98),
	printStats2('10, 	9: ', T99),
	printStats2('10, 	10: ', T100),
	readFromFile6(PredList),
	readFromFile7(WinList),
	predictWin(PredList, WinList),
	%%writeln(Content4),
	rankPrecision(high_card, Content4, PredList, WinList, NumHighCards),
	rankPrecision(pair, Content4, PredList, WinList, NumPairCards),
	rankPrecision(two_pair, Content4, PredList, WinList, NumTwoPairCards),
	rankPrecision(three_of_a_kind, Content4, PredList, WinList, NumThreeCards),
	rankPrecision(straight, Content4, PredList, WinList, NumStraightCards),
	rankPrecision(flush, Content4, PredList, WinList, NumFlushCards),
	rankPrecision(full_house, Content4, PredList, WinList, NumFHCards),
	rankPrecision(four_of_a_kind, Content4, PredList, WinList, NumFourKindCards),
	rankPrecision(straigh_flush, Content4, PredList, WinList, NumSFCards),
	rankPrecision(royal_flush, Content4, PredList, WinList, NumRFCards).
	
	%%
runLoop(Num, Count) :-
	setHand(H1, H2),									%% Set the hand
	sort_hand(H1, Sorted_Hand1),						%% Sort the hand1
	sort_hand(H2, Sorted_Hand2),						%% Sort the hand2
	solution(Sorted_Hand1, 'A2card3log.txt'),			%% Write the hand to an output file
	solution(Sorted_Hand2, 'A2card3logPlayer2.txt'),	%% Write the hand to an output file
	%%write('Players Hand:'), nl,						%% Printing to console for debugging
	%%print(Sorted_Hand1), nl,
	%%print(Sorted_Hand2), nl,
	determine_hand(Sorted_Hand1,  Rank1),			%% Determine the rank of the hand
	determine_hand(Sorted_Hand2,  Rank2),			%% Determine the rank of the hand
	(Rank1 = pair, cardCalcAux(Sorted_Hand1, Pred);
	 Rank1 = high_card, cardCalcAux2(Sorted_Hand1, Pred);
	 predictWin(Rank1, Pred)),
	solution(Pred, 'A2predictLog.txt'),
	%%format('Rank: ~w ~n', [Rank]),			%% Printing to console for debugging
	 beats(Rank1, Rank2, Verdict),
	(Verdict = Rank1, Winner = H1, solution(Rank1, 'A2card3GameLog.txt'), winnerLog(Rank1, 'A2card3WinnerLog_P1.txt'), winnerLog(Rank2, 'A2card3WinnerLog_P1.txt'),
		winnerLog_nl('A2card3WinnerLog_P1.txt'), player1Log(Rank1, 'A2card3P1_Winnings.txt'), solution(Rank1, 'A2card3P1_All_Hands.txt'), solution(win, 'A2winLog.txt');
   	 Verdict = Rank2, Winner = H2, solution(Rank2, 'A2card3GameLog.txt'), solution(Rank1, 'A2card3P1_All_Hands.txt'), solution(loss, 'A2winLog.txt');
  	 Verdict = tie, tiebreak(Rank1, Sorted_Hand1, Sorted_Hand2, SortedWinner),
    (SortedWinner = left, Winner = H1, solution(Rank1, 'A2card3GameLog.txt'), winnerLog(Rank1, 'A2card3WinnerLog_P1.txt'), solution(win, 'A2winLog.txt'),
    	winnerLog(Rank2, 'A2card3WinnerLog_P1.txt'), winnerLog_nl('A2card3WinnerLog_P1.txt'), solution(Rank1, 'A2card3P1_All_Hands.txt'), player1Log(Rank1, 'A2card3P1_Winnings.txt');
    SortedWinner = right, Winner = H2, solution(Rank2, 'A2card3GameLog.txt'), solution(loss, 'A2winLog.txt'), solution(Rank1, 'A2card3P1_All_Hands.txt'))),
	
	solution(Rank1, 'A2card3log.txt'),			        %% Write the rank to an output file
	solution(Rank2, 'A2card3logPlayer2.txt'),			%% Write the rank to an output file
	Y is Num - 1,										%% Subtract 1 from Num and repeat the loop
	runLoop(Y, Count).

predictWin(high_card, loss).
predictWin(pair, win).
predictWin(two_pair, win).
predictWin(three_of_a_kind, win).
predictWin(straight, win).
predictWin(flush, win).
predictWin(full_house, win).
predictWin(four_of_a_kind, win).
predictWin(straigh_flush, win).
predictWin(royal_flush, win).

predictWin(PredList, WinList) :-
	countPred(win, win, PredList, WinList, TP),
	countPred(loss, loss, PredList, WinList, TN),
	countPred(win, loss, PredList, WinList, FP),
	countPred(loss, win, PredList, WinList, FN),
	Precision is (TP + TN) / (TP + TN + FP + FN),
	format('TP: ~w TN: ~w FP: ~w FN: ~w~nPrecision: ~2f~n', [TP, TN, FP, FN, Precision]).

cardCalcAux(Hand, Pred) :-
	isolate_pair(Hand, Card, Rst1),
	cardCalc(Card, Pred).
	
%%stupidRule(win, win).
stupidRule(loss, loss).

cardCalcAux2(Hand, Pred) :-
	H1 = [_,_,_,_,[R,S]],
	(S = club, stupidRule(loss, Pred);
	 S = heart, stupidRule(loss, Pred);
	 S = diamond, stupidRule(loss, Pred);
	 S = spade, stupidRule(loss, Pred)
	 ).

cardCalc(ace, win).
cardCalc(king, win).
cardCalc(queen, win).
cardCalc(jack, win).
cardCalc(10, win).
cardCalc(9, win).
cardCalc(8, win).
cardCalc(7, win).
cardCalc(6, loss).
cardCalc(5, loss).
cardCalc(4, loss).
cardCalc(3, loss).
cardCalc(2, loss).
cardCalc(1, loss).

calcProb(WinRate, TotalNum, Prob) :-
    (TotalNum > 0, Prob is (WinRate / TotalNum * 100);
    TotalNum = 0, Prob is 0).
    
%% Resets the output file and runs the game loop Num times
runGame(Num) :-
	writeToFile('', 'A2card3WinnerLog_P1.txt'),
	writeToFile('', 'A2card3GameLog.txt'),
	writeToFile('', 'A2card3P1_All_Hands.txt'),
	writeToFile('', 'A2card3logPlayer2.txt'),
	writeToFile('', 'A2card3log.txt'),							%% Create and clear the output file
	writeToFile('', 'A2predictLog.txt'),
	writeToFile('', 'A2winLog.txt'),
	winnerLog(Num, 'A2card3WinnerLog_P1.txt'),
	solution(Num, 'A2card3GameLog.txt'),
	solution(Num, 'A2card3logPlayer2.txt'),
	solution(Num, 'A2card3log.txt'),							%% Write the how many times we will loop to the file
	writeToFile('', 'A2card3P1_Winnings.txt'),
	player1Log(Num, 'A2card3P1_Winnings.txt'),
	runLoop(Num, Num).												%% Run the game Num many times
	
	
/*	
	%%%%%% COUNTING THE WINNINGS OF PLAYER 1 FROM THE A2card3WinnerLog_P1.txt %%%%%%
	
	readFromFile3(Content3),									
	countRank(high_card, Content3, NumHighCards3),				
	countRank(pair, Content3, NumPairCards3),
	countRank(flush, Content3, NumFlushCards3),
	countRank(straight, Content3, NumStraightCards3),
	countRank(three_of_a_kind, Content3, NumThreeCards3),
	countRank(straight_flush, Content3, NumSFCards3),
	%% New Stuff
	countRank(royal_flush, Content3, NumRFCards3),
	countRank(four_of_a_kind, Content3, NumFourKindCards3),
	countRank(full_house, Content3, NumFHCards3),
	countRank(two_pair, Content3, NumTwoPairCards3),

%%NOTE: took out the \/ in all of Num

	HighCardTest3 is NumHighCards3  Num * 100,					
	PairTest3 is 	NumPairCards3  Num * 100,
	FlushTest3 is	NumFlushCards3  Num * 100,
	StraightTest3 is NumStraightCards3  Num * 100,
	ThreeTest3 is 	NumThreeCards3  Num * 100,
	SFTest3 is 		NumSFCards3  Num * 100,

	RFTest3 is 		NumRFCards3  Num * 100,
	FourKindTest3 is NumFourKindCards3  Num * 100,
	FHTest3 is 		NumFHCards3  Num * 100,
	TwoPairTest3	is	NumTwoPairCards3  Num * 100,
	
	print('WINNINGS OF PLAYER 1'), writeln(''),		%% Print the probabilities to the console
	printStats('Straight Flush Victories:      ', NumSFCards3, SFTest3),
	printStats('Three of a kind Victories:     ', NumThreeCards3, ThreeTest3),
	printStats('Straight Victories:            ', NumStraightCards3, StraightTest3),
	printStats('Flush Victories:               ', NumFlushCards3, FlushTest3),
	printStats('Pair Victories:                ', NumPairCards3, PairTest3),
	printStats('High Card Victories:           ', NumHighCards3, HighCardTest3),

	printStats('Royal Flush Card Victories:    ', NumRFCards3, RFTest3),
	printStats('Four of a kind Card Victories: ', NumFourKindCards3, FourKindTest3),
	printStats('Full House Card Victories:     ', NumFHCards3, FHTest3),
	printStats('TwoPair Card Victories:        ', NumTwoPairCards3, TwoPairTest3).
*/	


	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	


	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Tiebreaks
tiebreak(straight_flush, H1, H2, Winner)  :- higher_last_card(H1, H2, Winner).
tiebreak(four_of_a_kind, H1, H2, Winner)  :- higher_middle_card(H1, H2, Winner).
tiebreak(full_house, H1, H2, Winner)      :- higher_middle_card(H1, H2, Winner).
tiebreak(flush, H1, H2, Winner)           :- tiebreak(high_card, H1, H2, Winner).
tiebreak(straight, H1, H2, Winner)        :- higher_last_card(H1, H2, Winner).
tiebreak(three_of_a_kind, H1, H2, Winner) :- higher_middle_card(H1, H2, Winner).

tiebreak(two_pair, H1, H2, Winner) :-
  isolate_pairs(H1, [HighCard1,_], [LowCard1,_], Last1),
  isolate_pairs(H2, [HighCard2,_], [LowCard2,_], Last2),
  (beats_with_hand(H1, HighCard1, H2, HighCard2, Winner),
   Winner \= tie;
   beats_with_hand(H1, LowCard1, H2, LowCard2, Winner),
   Winner \= tie;
   beats_with_hand(H1, Last1, H2, Last2, Winner)).
     
tiebreak(pair, H1, H2, Winner) :-
  isolate_pair(H1, [PairCard1,_], Rst1),
  isolate_pair(H2, [PairCard2,_], Rst2),
  (beats_with_hand(H1, PairCard1, H2, PairCard2, Winner), Winner \= tie ;
   tiebreak(high_card, Rst1, Rst2, Winner)).

tiebreak(high_card, H1, H2, X) :- 
  reverse(H1, RevH1),
  reverse(H2, RevH2),
  highest_card_chain(RevH1, RevH2, X).


beats_with_hand(H1, C1, H2, C2, X) :-
  beats(C1, C2, C1), X = left ;
  beats(C1, C2, C2), X = right ;
  X = tie.

% Really ugly.  How to better do this?
isolate_pairs(Hand, High_Pair, Low_Pair, Last) :-
  [[V1,S1],[V2,S2],[V3,S3],[V4,S4],[V5,S5]] = Hand,
  (V5 = V4, High_Pair = [[V4,S4],[V5,S5]],
    (V3 = V2, Low_Pair = [[V3,S3],[V2,S2]], Last = [V1,S1] ;
     V1 = V2, Low_Pair = [[V1,S1],[V2,S2]], Last = [V3,S3])) ;
  (Low_Pair = [[V1,S1],[V2,S2]], 
   High_Pair = [[V3,S3],[V4,S4]],
   Last = [V5,S5]).

isolate_pair(Hand, Pair, Rst) :-
  [[V1,S1],[V2,S2],[V3,S3],[V4,S4],[V5,S5]] = Hand,
  (V1 = V2, Pair = [[V1,S1],[V2,S2]], Rst = [[V3,S3],[V4,S4],[V5,S5]] ;
   V2 = V3, Pair = [[V3,S3],[V2,S2]], Rst = [[V1,S1],[V4,S4],[V5,S5]] ;
   V4 = V3, Pair = [[V3,S3],[V4,S4]], Rst = [[V1,S1],[V2,S2],[V5,S5]] ;
   V4 = V5, Pair = [[V5,S5],[V4,S4]], Rst = [[V1,S1],[V2,S2],[V3,S3]]).
  

highest_card_chain([H1|T1], [H2|T2], X) :-
  beats(H1,H2,Verdict),
  (Verdict = H1, X = left ;
   Verdict = H2, X = right ;
   Verdict = tie, highest_card_chain(T1,T2,X)).

higher_last_card(H1,H2,Winner) :-
  H1 = [_,_,_,_,[V1,_]],
  H2 = [_,_,_,_,[V2,_]],
  beats(V1,V2,Higher),
  (Higher = V1, Winner = left ;
   Higher = V2, Winner = right).

higher_middle_card(H1, H2, Winner) :-
  H1 = [_,_,[V1,_],_,_],
  H2 = [_,_,[V2,_],_,_],
  beats(V1,V2,Higher),
  (Higher = V1, Winner = left;
   Higher = V2, Winner = right).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Hand determination
determine_hand([[10,X],[jack,X],[queen,X],[king,X],[ace,X]], royal_flush).

determine_hand([[A, X],[B,X],[C,X],[D,X],[E,X]], straight_flush) :-
  successor(E,D), successor(D,C), successor(C,B), successor(B,A).

determine_hand([[C,_],[A,_],[A,_],[A,_],[B,_]], four_of_a_kind) :-
  C = A ; B = A.

determine_hand([[A,_],[B,_],[C,_],[D,_],[E,_]], full_house) :-
  A = B, D = E, (C = D ; C = B).

determine_hand([[_,X],[_,X],[_,X],[_,X],[_,X]], flush).

determine_hand([[A,_],[B,_],[C,_],[D,_],[E,_]], straight) :-
  successor(E,D), successor(D,C), successor(C,B), successor(B,A).

determine_hand([[A,_],[B,_],[C,_],[D,_],[E,_]], three_of_a_kind) :-
  (A = B, B = C); (B = C, C = D); (C = D, D = E).

determine_hand([[A,_],[A,_],[B,_],[B,_],[_,_]], two_pair).
determine_hand([[_,_],[A,_],[A,_],[B,_],[B,_]], two_pair).
determine_hand([[A,_],[A,_],[_,_],[B,_],[B,_]], two_pair).

determine_hand([[A,_],[B,_],[C,_],[D,_],[E,_]], pair) :-
  A = B; B = C; C = D; D = E.

determine_hand(_,high_card).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%  Hand sorting (for easier pattern matching).
sort_hand([], []).
sort_hand([H|T], Sorted) :-
  filter_by_high_card(H,T,Lower,Higher),
  sort_hand(Lower,SortedLower),
  sort_hand(Higher,SortedHigher),
  append(SortedLower, [H|SortedHigher], Sorted).

filter_by_high_card(_, [], [], []).  
filter_by_high_card(Pivot, [H|T], [H|Lower], Higher) :-
  beats(Pivot,H,Z),
  (Z = Pivot ; Z = tie),
  filter_by_high_card(Pivot, T, Lower, Higher).
filter_by_high_card(Pivot, [H|T], Lower, [H|Higher]) :-
  beats(Pivot,H,H),
  filter_by_high_card(Pivot, T, Lower, Higher).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%  Card and Hand Precedence
beats([V,_],[V,_],tie).
beats([V1,S],[V2,_],[V1,S]) :- value_greater_than(V1,V2).
beats([V1,_],[V2,S],[V2,S]) :- value_greater_than(V2,V1).

beats(X,X,tie).
beats(X,Y,X) :- value_greater_than(X,Y).
beats(X,Y,Y) :- value_greater_than(Y,X).

successor(royal_flush, straight_flush).   successor(straigh_flush, four_of_a_kind).
successor(four_of_a_kind, full_house).    successor(full_house, flush).
successor(flush, straight).               successor(straight, three_of_a_kind).
successor(three_of_a_kind, two_pair).     successor(two_pair, pair).
successor(pair, high_card).

successor(ace,king).     successor(king,queen).   successor(queen,jack).
successor(jack,10).      successor(10,9).         successor(9,8).
successor(8,7).          successor(7,6).          successor(6,5).
successor(5,4).          successor(4,3).          successor(3,2).

%%Successor for suits
successor(clubs, heart).          successor(heart, diamond).          successor(diamond,spade).

value_greater_than(X,Y) :-
  successor(X,P),
  (Y = P;
  value_greater_than(P,Y)).
