%% Write a function which starts 2 processes, and sends a message M times
%% forewards and backwards between them. After the messages have been
%% sent the processes should terminate gracefully.

-module(question6).

-export([messenger/2, sender/0]).

messenger(Message, MTimes) ->
    P1 = spawn(?MODULE, sender, []),
    P2 = spawn(?MODULE, sender, []),
    io:format("sender 1 pid: ~p sender 2 pid: ~p~n", [P1, P2]),
    P1 ! {P2, Message, MTimes, parent},
    ok.

sender() ->
    receive
        {From, Msg, MTimes, parent} when MTimes > 0 ->
            io:format("Message: ~p from: ~p times: ~p~n", [Msg, From, MTimes]),
            From ! {self(), Msg, MTimes, child},
            sender();
        {From, Msg, MTimes, child} when MTimes > 0 ->
            io:format("Message: ~p from: ~p times: ~p~n", [Msg, From, MTimes]),
            From ! {self(), Msg, MTimes-1, parent},
            sender();
        _ ->
            done
    end.