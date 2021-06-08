-module(bigchaindb_port).

-behaviour(gen_server).

-export([start/0, stop/0, state/0,
                  stop/1, state/1,
         cmd/2, search/1
        ]).

-export([init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2, 
         terminate/2, 
         code_change/3]).

%% Public API

start()         -> gen_server:start({local, ?MODULE}, ?MODULE, [], []).
stop(Module)    -> gen_server:call(Module, stop).
stop()          -> stop(?MODULE).
state(Module)   -> gen_server:call(Module, state).
state()         -> state(?MODULE).

%:port_manager.cmd(:search, [:erlang.binary_to_list("test kokokoko")])
%:port_manager.cmd(:search, [:erlang.binary_to_list(Poison.encode!(%{key: "value", key3: "value3"}))])
%:port_manager.cmd(:search, [:erlang.binary_to_list(Poison.encode!(%{fields: ["f1", "key", "objects"], args: %{}}))])
cmd(Cmd, Args) -> gen_server:call(?MODULE, {call, Cmd, Args}).
search(Args)   -> cmd(search, Args). 

pyversion() -> os:getenv("PORTPYTHON", "python3").

%
%:bigchaindb_port.start
%arg = Jason.encode!(%{"public_key" => "BCjpjCCW1DVsNH2jFqc1v3BFozM6AFSPVPyMFVv5P58F", "private_key" => "23Wk3JchELr4yxEA59ar2zrUzArViQ9FRLNhdKg42E2g", "asset" => %{"a" => "1", "b" => "2"}})
%:bigchaindb_port.cmd(:transactioncreate, [:erlang.binary_to_list(arg)])
%


init([]) ->
  logger:debug("port manager initialization"),
  Port = open_port({spawn, pyversion() ++ " " ++ code:priv_dir(token_registry) ++ "/bigchaindb.py"}, [{packet, 4}, binary]),
  put(isdebug, true),
  {ok, #{port => Port}}.

handle_call({call, Cmd, Args}, _, #{port := Port} = State) ->
  logger:debug("port manager handle call ~p", [{Cmd, Args}]),
  CmdTuple = list_to_tuple([Cmd] ++ Args),
  logger:debug("port manager handle call cmdtuple ~p", [CmdTuple]),
  Port ! {self(), {command, term_to_binary(CmdTuple)}},
  {ok, Data} = get_python_data(),
  logger:debug("port manager call output  ~p", [Data]),
  {reply, Data, State};
handle_call(Request, From, State) ->
  logger:warning("unexpecting call ~p from ~p state: ~p", [Request, From, State]),
  {reply, ok, State}.


handle_cast(Request, State) ->
  logger:warning("unexpecting cast ~p  state: ~p", [Request, State]),
  {noreply, State}.


handle_info(Request, State) ->
  logger:warning("unexpecting info ~p  state: ~p", [Request, State]),
  {noreply, State}.


terminate(_Reason, #{port := Port} = _State) ->
  Port ! {self(), close},
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

to_binary(L) when is_list(L) -> list_to_binary(L);
to_binary(I) when is_integer(I) -> integer_to_binary(I);
to_binary(B) -> B.

get_python_data() ->
    receive
        {Port, {data, Msg}} when is_port(Port) ->
            Term = to_binary(binary_to_term(Msg)),
            case get(isdebug) of
                true -> logger:debug("!!port output!!: ~p", [Term])
                ;_   -> ok
            end,
            {ok, Term}
        after 60000 -> {error, [<<"timeout">>]}
    end.


