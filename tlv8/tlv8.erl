-module(tlv8).
-export([
  decode/1
]).

decode(Binary) ->
  case decode(Binary, #{}) of
    #{ invalid := Invalid } -> erlang:error(badarg, Invalid);
    Result -> Result
  end.

decode(<<>>, Acc) ->
  Acc;
decode(<<Type:8, Size:8, Value:(Size)/binary, NextBinary/binary>>, Acc) ->
  NextAcc = maps:put(Type, Value, Acc),
  decode(NextBinary, NextAcc);
decode(Binary, Acc) ->
  maps:put(invalid, Binary, Acc).

