%%%-------------------------------------------------------------------
%%% @author ayushkumar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2022 6:32 AM
%%%-------------------------------------------------------------------
-module(cpuStatsScheduler).
-author("ayushkumar and akashkumar").

%% API
-export([start/0]).
-export([stop/0]).
start() ->
  Time=statistics(scheduler_wall_time),
  io:format("~w",Time),
  timer:sleep(500),
  start().

stop() ->
  exit(normal).
