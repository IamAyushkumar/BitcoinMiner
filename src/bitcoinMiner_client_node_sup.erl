%%%-------------------------------------------------------------------
%% @doc BitcoinMiner public API
%% @end
%%%-------------------------------------------------------------------

-module(bitcoinMiner_client_node_sup).
-export([start_link/1, stop/0, message_receiver/0, proceed_to_spawn_all_actors/3, spawn_actor_and_listen/2]).
-define(GATOR_ID, "akashkumar;").

-record(state, {
    randomString,
    minLeadingZeroes
}).

start_link(SupervisorIpAddress) -> % will get called from console
    io:format("[start_link] initializing connection."),
    net_kernel:connect_node(SupervisorIpAddress),
    net_adm:ping(SupervisorIpAddress),
    io:format("[start_link] starting the main function upon getting call from server"),
    Pid = spawn_link(?MODULE, listen_for_supervisor,[]),
    register(?MODULE, Pid),
    {ok,Pid}.

stop() ->
    ?MODULE ! terminate.

message_receiver() ->
    receive
        {startProcessing, SupervisorPid, MinLeadingZeroes} ->
            error_logger:error_msg("actor died, respawning"),
            proceed_to_spawn_all_actors(SupervisorPid, 100, MinLeadingZeroes);
        terminate ->
            stop()
    end,
    message_receiver().

proceed_to_spawn_all_actors(SupervisorPid, NumActors, K)  when NumActors > 0 ->
    spawn(?MODULE, spawn_actor_and_listen, [SupervisorPid, K]),
    proceed_to_spawn_all_actors(SupervisorPid, NumActors - 1, K).

spawn_actor_and_listen(SupervisorPid, K) ->
    process_flag(trap_exit, true),
    {ok, ActorPid} = bitcoinMiner_client_actor:start_link(SupervisorPid, K),
    ActorPid ! {actorStartProcessing, self()},
    listen_actor(SupervisorPid, ActorPid, K).

listen_actor(SupervisorPid, ActorPid, K) ->
    receive
        {'EXIT', ActorPid, _} ->
            error_logger:error_msg("actor died, respawning"),
            {ok, ActorNewPid} = bitcoinMiner_client_actor:start_link(SupervisorPid, K),
            listen_actor(SupervisorPid, ActorNewPid, K);
        {actorFoundCoin, FinderActorPid, RandomStringUsed, BitcoinGeneratedHash} ->
            send_found_message_to_supervisor(SupervisorPid, FinderActorPid, RandomStringUsed, BitcoinGeneratedHash);
        terminate ->
            bitcoinMiner_client_actor:stop()
    end,
    listen_actor(SupervisorPid, ActorPid, K).


send_found_message_to_supervisor(SupervisorPid, FinderActorPid, RandomStringUsed, BitcoinGeneratedHash) ->
    SupervisorPid ! {nodeFoundCoin, self(), RandomStringUsed, BitcoinGeneratedHash}.