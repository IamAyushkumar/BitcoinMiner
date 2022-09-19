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


