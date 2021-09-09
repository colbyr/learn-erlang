-module(tlv8).
-export([
  decode/1,
  decode_by_schema/2
]).

-define(LIST_SEPARATOR, <<16#FF, 16#00>>).

decode(Binary) ->
  BinaryEntries = binary:split(Binary, ?LIST_SEPARATOR),
  [decode_entry(Entry) || Entry <- BinaryEntries].

decode_entry(Binary) ->
  case decode_entry(Binary, #{}) of
    #{ invalid := Invalid } -> erlang:error(badarg, Invalid);
    Result -> Result
  end.

decode_entry(<<>>, Acc) ->
  Acc;
decode_entry(<<Type:8, Size:8, Value:(Size)/binary, NextBinary/binary>>, Acc) ->
  NextAcc = maps:put(Type, Value, Acc),
  decode_entry(NextBinary, NextAcc);
decode_entry(Binary, Acc) ->
  maps:put(invalid, Binary, Acc).

% #{ 16#01 => {name, value_converter} }
%

get_key_by_schema(Key, Schema) ->
  case maps:get(Key, Schema, undefined) of
    {NamedKey, _} -> NamedKey;
    undefined -> Key
  end.

get_value_by_schema(Key, Value, Schema) ->
  case maps:get(Key, Schema, undefined) of
    {_, bytes} -> Value;
    {_, integer} ->
      <<Int/integer>> = Value,
      Int;
    {_, utf8} -> binary_to_list(Value);
    {_, _} -> Value;
    undefined -> Value
  end.


decode_by_schema(Schema, Binary) ->
  [decode_entry_by_schema(Schema, Entry) || Entry <- decode(Binary)].

decode_entry_by_schema(Schema, RawData) ->
  SchemafiedList = [{
    get_key_by_schema(K, Schema),
    get_value_by_schema(K, V, Schema)
   } || {K, V} <- maps:to_list(RawData)],
  maps:from_list(SchemafiedList).

