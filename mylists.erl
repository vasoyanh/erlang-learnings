-module(mylists).

-export([min/1,max/1,min_max/1, member/2, delete/2]).

-compile({no_auto_import,[min/2]}).
-compile({no_auto_import,[max/2]}).
%% Write a function mylists:min(L) which returns the minimum element of the list L.
min([H|T]) ->
	min(H, T).

min(Min, [H|T]) ->
	if Min > H ->
			min(H, T);
	   true ->
			min(Min, T)
	end;

min(Min, []) ->
	Min.

%% Write a function mylists:max(L) which returns the maximum element of the list L.
max([H|T]) ->
	max(H, T).

max(Max, [H|T]) ->
	if Max > H ->
			max(Max, T);
	   true ->
			max(H, T)
	end;

max(Max, []) ->
	Max.

%% Write a function mylists:min_max(L) which returns a tuple
%% containing the minimum and the maximum elements of the list L.
min_max(List) ->
	{min(List), max(List)}.


%% Write a function mylists:member(E, L) which returns true
%% if the term E is in the list L and false otherwise.
member(_, []) ->
	false;

member(E,L) ->
	[H|T] = L,
	case E == H of
		true -> true;
		false -> member(E,T)
	end.

%% Write a function mylists:delete(E, L) which returns a new list
%% where the first occurrence of element E is deleted.

delete(E,L) ->
	L -- [E].