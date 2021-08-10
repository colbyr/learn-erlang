-module(reverse_str_tests).
-include_lib("eunit/include/eunit.hrl").

reverse_test() ->
	[] = reverse_str:reverse([]),
	["x"] = reverse_str:reverse(["x"]),
	["o", "l", "l", "e", "h"] = reverse_str:reverse(["h", "e", "l", "l", "o"]).
