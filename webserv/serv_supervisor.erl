-module(serv_supervisor).
-behavior(supervisor).

-export([start_link/0, start_socket/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, ListenSocket} = gen_tcp:listen(8088, [{active, once}]),
  % this is like setTimeout(empty_listeners, 0)
  % so it doesnt run until after init is complete
  spawn_link(fun empty_listeners/0),
  {ok, {{simple_one_for_one, 60, 3600},
    [{socket,
    {http_ok, start_link, [ListenSocket]}, % pass the socket!
     temporary, 1000, worker, [http_ok]}
    ]}}.

start_socket() ->
  supervisor:start_child(?MODULE, []).

%% Start with 20 listeners so that many multiple connections can
%% be started at once, without serialization. In best circumstances,
%% a process would keep the count active at all times to insure nothing
%% bad happens over time when processes get killed too much.
empty_listeners() ->
  [start_socket() || _ <- lists:seq(1,20)],
  ok.


