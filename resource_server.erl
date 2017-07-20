%% Rewrite the resource server above so that it can be started with a list of resources.
%% The reserve and release functions should take one argument which is the name of the 
%% resource and either return {ok,Resource} if the resource is available or otherwise unavailable.

-module(resource_server).
 
-export([start/1, server/1]).
 
-export([reserve/1, release/1, is_available/1, check_resource/0]).

reserve(Resource) ->
    ?MODULE ! {self(), reserve, Resource},
    receive
        {?MODULE, Reply} ->
            Reply
    end.
 
release(Resource) ->
    ?MODULE ! {self(), release, Resource},
    receive
        {?MODULE, Reply} ->
            Reply
    end.
 
is_available(Resource) ->
    ?MODULE ! {self(), is_available, Resource},
    receive
        {?MODULE, Reply} ->
            Reply
    end.

check_resource() ->
    ?MODULE ! {self(), check_resource},
    receive
        {?MODULE, Reply} ->
            Reply
    end.

start(ResourceList) ->
    Pid = spawn(?MODULE, server, [ResourceList]),
    register(?MODULE, Pid),
    ok.
 
server(ResourceList) ->
    io:format("I am here with resources~p\n", [ResourceList]),
    loop(ResourceList, ResourceList).
 
loop(ResourceList, OrigResourceList) ->
    receive
        {From, reserve, Resource} ->
            case lists:member(Resource, ResourceList) of
                true -> 
                    NewResourceList = lists:delete(Resource, ResourceList),
                    From ! {?MODULE, {ok, Resource}},
                    loop(NewResourceList, OrigResourceList);
                false ->
                    case lists:member(Resource, OrigResourceList) of
                        true ->
                            From ! {?MODULE, unavailable},
                            loop(ResourceList, OrigResourceList);
                        false ->
                            From ! {?MODULE, not_original_member},
                            loop(ResourceList, OrigResourceList)
                    end
            end;
        {From, release, Resource} ->
            case lists:member(Resource, ResourceList) of
                true ->
                    From ! {?MODULE, already_released},
                    loop(ResourceList, OrigResourceList);
                false ->
                    case lists:member(Resource, OrigResourceList) of
                        true ->
                            NewResourceList = lists:append([Resource], ResourceList),
                            From ! {?MODULE, ok},
                            loop(NewResourceList, OrigResourceList);
                        false ->
                            From ! {?MODULE, not_original_member},
                            loop(ResourceList, OrigResourceList)
                    end
            end;
        {From, is_available, Resource} ->
            case lists:member(Resource, ResourceList) of
                true ->
                    From ! {?MODULE, true},
                    loop(ResourceList, OrigResourceList);
                false ->
                    From ! {?MODULE, false},
                    loop(ResourceList, OrigResourceList)
            end;
        {From, check_resource} ->
            From ! {?MODULE, ResourceList},
            loop(ResourceList, OrigResourceList)
    end.

    
