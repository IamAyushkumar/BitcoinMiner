%%%-------------------------------------------------------------------
%%% @author ayushkumar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Sep 2022 4:04 AM
%%%-------------------------------------------------------------------
-module(bitcoinMinerActorProcess).
-author("ayushkumar and akashkumar").
%%-record(state, {minLeadingZeroes, callerPid}).
-define(GATOR_ID, "ayushakash;").

%% API
-export([start_link/3, stop/0, actor_process_main_loop/3, get_random_string/0, get_leading_zeroes/2, get_sha_256/1]).

start_link(CallerPid, MinLeadingZeroes, SupervisorPid) ->
  %io:format("\nprocess got started"),
  actor_process_main_loop(CallerPid, MinLeadingZeroes, SupervisorPid).

stop() ->
  exit(normal).

actor_process_main_loop(CallerPid, MinLeadingZeroes, SupervisorPid) ->
  %io:format("\nstarting main_loop of process."),
  RandomString = get_random_string(),
  Sha256 = get_sha_256([?GATOR_ID| RandomString]),
  CurrLeadingZeroes = get_leading_zeroes(Sha256, 0),
  if CurrLeadingZeroes >= MinLeadingZeroes -> CallerPid ! {actorFoundCoin, RandomString, Sha256};
  true -> io:format("\n Couldn't find")
  end,
  actor_process_main_loop(CallerPid, MinLeadingZeroes, SupervisorPid).

get_leading_zeroes([First|Rest], Count) ->
  case First of
    48 -> get_leading_zeroes(Rest, Count+1);
    _ -> Count
  end.

get_sha_256(String) ->
  ShaList = integer_to_list(binary:decode_unsigned(crypto:hash(sha256, String)), 16),
  ShaList.

get_random_string() ->
  binary_to_list(base64:encode(crypto:strong_rand_bytes(16))).
