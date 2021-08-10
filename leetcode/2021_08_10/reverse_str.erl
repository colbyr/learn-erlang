-module(reverse_str).
-export([reverse/1]).

reverse([]) ->
	[];

reverse([First]) ->
	[First];

reverse([First|Rest]) ->
	reverse(Rest) ++ [First].

