%%%-------------------------------------------------------------------
%% @doc BitcoinMiner top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(bitcoinMinerServer).
-author("ayushkumar and akashkumar").
-export([start/1, start_all_nodes/1, to_all_nodes/2, init/1, main_listener_loop/0, stop/0]).

start(MinLeadingZeroes) ->
  Pid = spawn(?MODULE, init, [MinLeadingZeroes]),
  register(?MODULE, Pid).

init(MinLeadingZeroes) ->
  start_all_nodes(MinLeadingZeroes),
  %cpu_stats_scheduler:start(),
  main_listener_loop().

start_all_nodes(MinLeadingZeroes) ->
  AllNode = nodes(),
  to_all_nodes(AllNode,MinLeadingZeroes).

to_all_nodes([ClientToStart | RemainingClients], MinLeadingZeroes)->
  To_call = ClientToStart,
  To_call ! {startProcessing, self(), MinLeadingZeroes},
  to_all_nodes([RemainingClients], MinLeadingZeroes).

main_listener_loop()->
  receive
    {nodeFoundCoin, RandomStringUsed, BitcoinGeneratedHash} -> io:format(RandomStringUsed ++ " " ++ BitcoinGeneratedHash);
    terminate ->
      exit(normal)
  end,
  main_listener_loop().

stop() ->
  ?MODULE ! terminate.


