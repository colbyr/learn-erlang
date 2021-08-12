-module(decoder).
-export([decode_str/1]).

decode_str(Str) ->
  Matches = re:run(Str, "\\d\\[", [global, {capture, all, list}]),
  Str.
