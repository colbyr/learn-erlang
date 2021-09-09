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

decode_by_schema_test() ->
  ?assertMatch(
    #{ 16#ff := <<16#01, 16#02, 16#03>> },
    tlv8:decode_by_schema(
      #{},
      <<16#ff, 16#03, 16#01, 16#02, 16#03>>
    )
  ),

  ?assertMatch(
    #{ test := 1 },
    tlv8:decode_by_schema(
      #{ 16#ff => {test, integer} },
      <<16#ff, 16#01, 16#01>>
    )
  ),

  ?assertMatch(
    #{ test := "wow" },
    tlv8:decode_by_schema(
      #{ 16#ff => {test, utf8} },
      <<16#ff, 16#03, 119, 111, 119>>
    )
  ),

  ?assertMatch(
    #{ one := 1, two := "two", three := <<3>> },
    tlv8:decode_by_schema(
      #{ 16#01 => {one, integer}, 16#02 => {two, utf8}, 16#03 => {three, bytes} },
      <<
        16#01, 16#01, 16#01,
        16#02, 16#03, 116, 119, 111,
        16#03, 16#01, 16#03
      >>
    )
  ).
