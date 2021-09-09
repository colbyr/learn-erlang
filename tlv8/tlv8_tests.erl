-module(tlv8_tests).
-include_lib("eunit/include/eunit.hrl").

decode_test() ->
  ?assertMatch(
    #{},
    tlv8:decode(<<>>)
  ),

  ?assertMatch(
    #{ 16#ff := <<16#01, 16#02, 16#03>> },
    tlv8:decode(<<16#ff, 16#03, 16#01, 16#02, 16#03>>)
  ),

  ?assertMatch(
    #{
      16#ff := <<16#01, 16#02, 16#03>>,
      16#00 := <<16#01, 16#02>>,
      16#0f := <<16#01, 16#02, 16#03, 16#04>>
    },
    tlv8:decode(
      <<
        16#ff, 16#03, 16#01, 16#02, 16#03,
        16#00, 16#02, 16#01, 16#02,
        16#0f, 16#04, 16#01, 16#02, 16#03, 16#04
      >>
    )
  ),

  ?assertError(
    badarg,
    tlv8:decode(<< 16#ff, 16#05, 16#01, 16#02, 16#03 >>)
  ).

