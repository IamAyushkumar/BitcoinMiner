%%%-------------------------------------------------------------------
%%% @author ayushkumar
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. Sep 2022 7:36 AM
%%%-------------------------------------------------------------------
-module(utility).
-author("ayushkumar").

%% API
-export([get_leading_zeroes/2]).

get_leading_zeroes([First|Rest], Count) ->
  case First of
    48 -> get_leading_zeroes(Rest, Count+1);
    _ -> Count
  end.
