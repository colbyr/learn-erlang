-module(fibonacci).
-export([nth/1]).

fib_tail(N) ->
  fib_tail(N - 1, 1, 0).
fib_tail(0, F, _) ->
  F;
fib_tail(N, F, F_1) ->
  fib_tail(N - 1, F + F_1, F).

nth(0) ->
  0;
nth(1) ->
  1;
nth(N) when N > 1 ->
  fib_tail(N).
