%%%-------------------------------------------------------------------
%% @doc BitcoinMiner public API
%% @end
%%%-------------------------------------------------------------------

-module(bitcoinMinerClientNodeSup).
-author("ayushkumar and akashkumar").
-export([start_link/1, stop/0, message_receiver/0, proceed_to_spawn_all_actors/3, spawn_actor_and_listen/2,listen_actor/3,send_found_message_to_supervisor/3]).
-define(GATOR_ID, "akashkumar;").

start_link(SupervisorIpAddress) -> % will get called from console
    net_kernel:connect_node(SupervisorIpAddress),
    net_adm:ping(SupervisorIpAddress),
    Pid = spawn_link(?MODULE, message_receiver,[]),
    register(?MODULE, Pid),
    Pid.

stop() ->
    ?MODULE ! terminate.

message_receiver() ->
    receive
        {startProcessing, SupervisorPid, MinLeadingZeroes} ->
            %error_logger:error_msg("actor died, respawning"),
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
            %error_logger:error_msg("actor died, respawning"),
            {ok, ActorNewPid} = bitcoinMiner_client_actor:start_link(SupervisorPid, K),
            listen_actor(SupervisorPid, ActorNewPid, K);
        {actorFoundCoin,RandomStringUsed, BitcoinGeneratedHash} ->
            send_found_message_to_supervisor(SupervisorPid, RandomStringUsed, BitcoinGeneratedHash);
        terminate ->
            bitcoinMiner_client_actor:stop()
    end,
    listen_actor(SupervisorPid, ActorPid, K).

send_found_message_to_supervisor(SupervisorPid, RandomStringUsed, BitcoinGeneratedHash) ->
    SupervisorPid ! {nodeFoundCoin, RandomStringUsed, BitcoinGeneratedHash}.