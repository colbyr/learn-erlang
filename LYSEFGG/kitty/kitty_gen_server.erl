-module(kitty_gen_server).

-compile(export_all).

-behavior(gen_server).

-record(cat, {name, color = green, description}).

start_link() ->
  gen_server:start_link(?MODULE, [], []).

order_cat(Pid, Name, Color, Description) ->
  gen_server:call(Pid, {order, Name, Color, Description}).

return_cat(Pid, Cat = #cat{}) ->
  gen_server:call(Pid, {return, Cat}).

close_shop(Pid) ->
  gen_server:call(Pid, terminate).

init([]) ->
  {ok, []}.

handle_call({order, Name, Color, Description}, _From, Cats) ->
  if Cats =:= [] ->
       {reply, make_cat(Name, Color, Description), Cats};
     Cats =/= [] ->
       {reply, hd(Cats), tl(Cats)}
  end;
handle_call(terminate, _From, Cats) ->
  {stop, normal, ok, Cats}.

handle_cast({return, Cat = #cat{}}, Cats) ->
  {noreply, [Cat|Cats]}.

handle_info(Msg, Cats) ->
  io:format("Unexpected message: ~p~n",[Msg]),
  {noreply, Cats}.

terminate(normal, Cats) ->
  [io:format("~p was set free.~n",[C#cat.name]) || C <- Cats],
  ok.

code_change(_OldVsn, State, _Extra) ->
  %% No change planned. The function is there for the behaviour,
  %% but will not be used. Only a version on the next
  {ok, State}.

%%% Private functions
make_cat(Name, Col, Desc) ->
  #cat{name = Name,
       color = Col,
       description = Desc}.
