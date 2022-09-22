%%%-------------------------------------------------------------------
%% @doc BitcoinMiner public API
%% @end
%%%-------------------------------------------------------------------

-module(BitcoinMiner_app).
-behaviour(application).
-export([start/2, stop/0]).
-define(GATOR_ID, "54666085").
-record(state, {
    randomString,
    minLeadingZeroes
}).

start(_StartType, _StartArgs) ->
    Pid = spawn_link(?MODULE, init(), []),
    register(?MODULE, Pid).
%%    BitcoinMiner_sup:start_link().

stop() ->
    ?MODULE ! terminate.

%% internal functions


init() ->
    String = binary_to_list(base64:encode(crypto:strong_rand_bytes(16))),
    MinLeadingZeroes = 1,
    State = #state{randomString = String, minLeadingZeroes = MinLeadingZeroes},
    main_loop(State),
    ?MODULE ! {start, self()},
    receive
        {found, RandomString} -> io:format("Found a bitcoin " + RandomString)
    end.


main_loop(#state{
    randomString = RandomString,
    minLeadingZeroes = MinLeadingZeroes
} = State) ->
    receive
        {start, CallerPid} ->
         Sha256 = get_sha_256([?GATOR_ID|RandomString]),
         CurrLeadingZeroes = get_leading_zeroes(Sha256, 0),
            if
                CurrLeadingZeroes >= MinLeadingZeroes -> CallerPid ! {found, RandomString}
            end,
            main_loop(State#state{randomString = binary_to_list(base64:encode(crypto:strong_rand_bytes(16))), minLeadingZeroes = MinLeadingZeroes});
        terminate -> exit(normal)
    end.

get_leading_zeroes([H|T], Count) ->
    case H of
        "0" -> get_leading_zeroes(T, Count+1);
        _ -> Count
end.

get_sha_256(String) ->
    integer_to_list(binary:decode_unsigned(crypto:hash(sha256, String)), 16).

%%increment_randomized_string(String) ->
%%    [First|Second] = re:split(String, ":"),
%%    SecondInteger = list_to_integer(Second) + 1.
%%    increment_string_util(Second)
%%
%%increment_string_util([H|T], Accumulator) ->
%%    if
%%        ("a" >= H and "z" >= H) -> H = H+1, [H|T];
%%        true -> increment_string_util(T, [Accumulator|H])
%%    end.



