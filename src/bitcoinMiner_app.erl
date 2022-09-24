%%%-------------------------------------------------------------------
%% @doc BitcoinMiner public API
%% @end
%%%-------------------------------------------------------------------

-module(bitcoinMiner_app).
-export([start_link/1, stop/0]).
-export([init/1]).
-define(GATOR_ID, "akash.kumar;").
-record(state, {
    randomString,
    minLeadingZeroes
}).

start_link(N) ->
    Pid = spawn_link(?MODULE, init,[N]),
    register(?MODULE, Pid),
    {ok,Pid}.
%%    BitcoinMiner_sup:start_link().

stop() ->
    ?MODULE ! terminate.

%% internal functions

init(Number_of_leading_zero) ->
    String = binary_to_list(base64:encode(crypto:strong_rand_bytes(16))),
    MinLeadingZeroes = Number_of_leading_zero,
    State = #state{randomString = String, minLeadingZeroes = MinLeadingZeroes},
    main_loop(State), ?MODULE ! {start, self()},
    receive
        {found, RandomString, Sha256} -> io:format([?GATOR_ID|RandomString] ++ " "++Sha256 ++ "\n")
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
                CurrLeadingZeroes >= MinLeadingZeroes -> CallerPid ! {found, RandomString, Sha256 }
            end,
            main_loop(State#state{randomString = binary_to_list(base64:encode(crypto:strong_rand_bytes(16))), minLeadingZeroes = MinLeadingZeroes});
        terminate -> exit(normal)
    end.

get_leading_zeroes([First|Rest], Count) ->
    case First of
        "0" -> get_leading_zeroes(Rest, Count+1);
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



