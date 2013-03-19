-module(tcpserver).

-export([start/0]).

-export([listen/1, accept/1, handle/1]).

start() ->
  Pid = spawn_link(?MODULE, listen, [4444]),
  {ok, Pid}.

listen(Port) ->
  {ok, ListenSocket} = gen_tcp:listen(Port, [{active, true}, binary]),
  accept(ListenSocket),
  timer:sleep(infinity).

accept(Socket) ->
  {ok, AcceptSocket} = gen_tcp:accept(Socket),
  spawn(?MODULE, handle, [AcceptSocket]),
  accept(Socket).

handle(Socket) ->
  %inet:setopts(Socket, [{active, once}]),
  receive
    {tcp, Socket, <<"quit", _/binary>>} ->
      gen_tcp:close(Socket);
    {tcp, Socket, _} ->
      gen_tcp:send(Socket, "hello"),
      handle(Socket)
  end.
  




