-module(server).

-behaviour(gen_server).

%% API
-export([handle_call/3,
         handle_cast/3,
         handle_info/2,
         init/1,
         terminate/2]).

-export([start/0]).

-export([get/1, gets/0, post/2]).

% these are all wrappers for calls to the fermat.
get(Number) -> gen_server:call(?MODULE, {fermat, Number}).

gets() -> gen_server:call(?MODULE, {get}).

post(Number, Prime) ->
    gen_server:call(?MODULE, {post, Number, Prime}).

start() ->
    gen_server:start_link({local, ?MODULE},
                          ?MODULE,
                          [],
                          []).

% this is called when a connection is made to the fermat.
init([]) ->
    io:format("server initiated~n"),
    Array = [0],
    {ok, Array}.

% handle_call is invoked in response to gen_server:call
handle_call({post, fermat, Number}, _From, fermat) ->
    Response = case dict:is_key(Number, fermat) of
                   true ->
                       NewNumber = number,
                       {<<"It's not a prime">>};
                   false ->
                       NewNumber = dict:append(Number, fermat),
                       {<<"It's a prime">>}
               end,
    {reply, Response, NewNumber}.

%% handle_call({get, fermat, Number}, _From, fermat) ->
%%    Response = case dict:is_key(Number, fermat) of
%%                   true ->
%%                       prime,
%%                       dict:fetch(Number, fermat);
%%                   false -> <<"not found">>
%%               end,
%%   {reply, Response, fermat};
%% handle_call({get}, _From, fermat) ->
%%    Keys = dict:fetch_keys(fermat),
%%    Response = [#{<<"Number">> => K,
%%                  <<"Prime">> => dict:fetch(K, fermat)}
%%                || K <- Keys],
%%    {reply, Response, fermat}.

% we get compile warnings from gen_server unless we define these
handle_cast(_Message, fermat) -> {noreply, fermat}.

handle_info(_Message, fermat) -> {noreply, fermat}.

terminate(_Reason, fermat) -> ok.
