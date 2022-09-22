%%%-------------------------------------------------------------------
%% @doc BitcoinMiner top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(bitcoinMiner_sup).

-export([start/0]).

-export([init/1]).
-export([stop/0]).
%%-export([start_link/0]).
-define(SERVER, ?MODULE).
%%
%%start_link() ->
%%    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%init([]) ->
%%    SupFlags = #{strategy => one_for_all,
%%                 intensity => 0,
%%                 period => 1},
%%    ChildSpecs = [],
%%    {ok, {SupFlags, ChildSpecs}}.

%% internal functions

start() ->
  Number_of_leading_zero=2,
  Pid = spawn(?MODULE, init, [Number_of_leading_zero]),
  register(?MODULE, Pid).

stop() ->
  ?MODULE ! terminate.

init(Number_of_leading_zero) ->
  process_flag(trap_exit, true),
  {ok, SupervisedPid} = bitcoinMiner_app:start_link(Number_of_leading_zero),
  main_loop(SupervisedPid,Number_of_leading_zero).

main_loop(SupervisedPid,Number_of_leading_zero) ->
  receive
    {'EXIT', SupervisedPid, _} ->
      {ok, NewPid} = bitcoinMiner_app:start_link(Number_of_leading_zero),
      main_loop(NewPid,Number_of_leading_zero);
    terminate ->
      bitcoinMiner_app:stop()
  end.