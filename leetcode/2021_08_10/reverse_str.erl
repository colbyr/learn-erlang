-module(reverse_str).

-export([reverse/1]).

reverse(Chars) when length(Chars) =< 1 ->
	Chars;
reverse(Chars) when length(Chars) > 1 ->
	[First|Rest] = Chars,
	reverse(Rest) ++ [First].
	
