-module(tlv8).
-export([
  decode/1
]).

decode(Binary) ->
  decode(Binary, #{}).

decode(<<>>, Acc) ->
  Acc;
decode(<<Type:8, Size:8, Value:(Size)/binary, NextBinary/binary>>, Acc) ->
  NextAcc = maps:put(Type, Value, Acc),
  decode(NextBinary, NextAcc).

