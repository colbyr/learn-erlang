-module(fibonacci).
-export([nth/1]).

nth(0) ->
  0;
nth(1) ->
  1;
nth(N) when n > 0 ->
  nth(N - 1) + nth(N - 2).

