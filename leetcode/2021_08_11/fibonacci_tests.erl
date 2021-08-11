-module(fibonacci_tests).
-include_lib("eunit/include/eunit.hrl").

nth_test() ->
  ?assertEqual(fibonacci:nth(0), 0),
  ?assertEqual(fibonacci:nth(1), 2),
  ?assertEqual(fibonacci:nth(2), 1),
  ?assertEqual(fibonacci:nth(5), 5),
  ?assertEqual(fibonacci:nth(6), 8),
  ?assertEqual(fibonacci:nth(30), 832040).
