-module(sample_cycle).
-behaviour(gen_cycle).

-export([start/1, start/2,
         init_cycle/1,
         handle_cycle/1,
         handle_info/2]).

start(Args) ->
    gen_cycle:start_supervised(?MODULE, Args).

start(Name, Args) ->
    gen_cycle:start_supervised(Name, ?MODULE, Args).

init_cycle(abort) ->
    ignore;
init_cycle([TestProcess, Interval, CallbackReply]) ->
    {ok, {Interval, {TestProcess, CallbackReply}}};
init_cycle([TestProcess, Interval]) ->
    {ok, {Interval, TestProcess}};
init_cycle([Interval]) ->
    {ok, {Interval, noop}}.

handle_cycle({TestProcess, CallbackReply})
  when is_pid(TestProcess) ->
    TestProcess ! cycle_handled,
    CallbackReply;
handle_cycle(TestProcess)
  when is_pid(TestProcess) ->
    TestProcess ! cycle_handled,
    {continue, TestProcess};
handle_cycle(noop) ->
    {continue, noop}.

handle_info(Msg, TestProcess) ->
    TestProcess ! {info_handled, Msg},
    {continue, TestProcess}.
