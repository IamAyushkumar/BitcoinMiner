%%%-------------------------------------------------------------------
%%% @author ayushkumar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2022 6:32 AM
%%%-------------------------------------------------------------------
-module(cpu_stats_scheduler).
-author("ayushkumar").

%% API
-export([start/0]).

start() ->
  Time=statistics(scheduler_wall_time),
  io:format("~w",Time),
  timer:sleep(500),
  start().

stop() ->
  exit(normal).
