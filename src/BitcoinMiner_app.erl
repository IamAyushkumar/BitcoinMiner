%%%-------------------------------------------------------------------
%% @doc BitcoinMiner public API
%% @end
%%%-------------------------------------------------------------------

-module(BitcoinMiner_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    BitcoinMiner_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

-define(DECODED_STRING, "abcdef00").
-define(GATOR_ID, "54666085").


get_leading_zeroes(String) ->
    get_leading_zeroes(String, 0).


get_leading_zeroes([H|T], Count) ->
    case H of
        "0" -> get_leading_zeroes(T, Count+1);
        _ -> Count
end.
