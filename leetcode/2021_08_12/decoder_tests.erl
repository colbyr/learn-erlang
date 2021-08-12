-module(decoder_tests).
-include_lib("eunit/include/eunit.hrl").

decode_str_test() ->
  ?assertEqual(decoder:decode_str("3[a]2[bc]"), "aaabcbc"),
  ok.
