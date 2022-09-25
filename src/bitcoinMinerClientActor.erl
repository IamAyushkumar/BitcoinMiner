%%%-------------------------------------------------------------------
%%% @author ayushkumar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2022 2:54 AM
%%%-------------------------------------------------------------------
-module(bitcoinMinerClientActor).
-author("ayushkumar and akashkumar").

%% API
-export([start_link/2, actor_main_loop/2, stop/0]).

start_link(SupervisorPid, MinLeadingZeroes) ->
  %io:format("----> [Actor] Spawning actor.~n"),
  Pid = spawn_link(?MODULE, actor_main_loop, [MinLeadingZeroes, SupervisorPid]),
  register(?MODULE, Pid),
  Pid.

stop() ->
  ?MODULE ! terminate.

actor_main_loop(MinLeadingZeroes, SupervisorPid) ->
  %io:format("\n [actor_main_loop] ready to receive."),
  receive
    {actorStartProcessing, CallerPid} ->
      bitcoinMinerActorProcess:start_link(CallerPid, MinLeadingZeroes, SupervisorPid);
    terminate ->  bitcoinMinerActorProcess:stop()
  end,
  actor_main_loop(MinLeadingZeroes, SupervisorPid).