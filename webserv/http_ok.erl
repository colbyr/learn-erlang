-module(http_ok).
-behavior(gen_server).
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
code_change/3, terminate/2]).

start_link(ListenSocket) ->
  gen_server:start_link(?MODULE, ListenSocket, []).

init(ListenSocket) ->
  gen_server:cast(self(), accept),
  {ok, {ListenSocket, rand:uniform(100)}}.

handle_call(_E, _From, State) ->
  {noreply, State}.

handle_cast(accept, {ListenSocket, WorkerId}) ->
  {ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
  io:format("Worker ~p: Connected~n", [WorkerId]),
  % Once this worker has accepts a request,
  % start up another worker to take its place.
  % Without this call, we would eventually exhaust out worker pool
  % and no more requests would be served.
  serv_supervisor:start_socket(),
  inet:setopts(AcceptSocket, [{active, once}]),
  {noreply, {AcceptSocket, WorkerId}}.

handle_info({tcp, _Socket, Req}, {AcceptSocket, WorkerId}) ->
  io:format(Req),
  Response = "HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8

It me, Erlang. Everything is ok.
",
  ok = gen_tcp:send(AcceptSocket, Response),
  io:format("Worker ~p: Sent OK~n", [WorkerId]),
  ok = gen_tcp:close(AcceptSocket),
  io:format("Worker ~p: Closed~n", [WorkerId]),
  {stop, normal, {AcceptSocket, WorkerId}}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

terminate(normal, {_, WorkerId}) ->
  io:format("Worker ~p: Shutting down~n", [WorkerId]),
  ok;
terminate(_Reason, {_, WorkerId}) ->
  io:format("Worker ~p terminate reason: ~p~n", [WorkerId, _Reason]).

