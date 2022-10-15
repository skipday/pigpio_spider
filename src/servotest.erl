-module(servotest).
-author(ama).
-export([start/0,init/0,loop/1]).
-define(UINT,32/little).

start() -> Pid = spawn_link(?MODULE,init,[]), {ok,Pid}.

init() ->
        {ok, Pid} = pigpio:start(),
        Pid ! {setmode, 4, 1},
        self() ! {center},
        loop(Pid).

loop(Pid) ->
        receive
                {center} -> 
                        Pid ! {servo_pos, 4, 1500},
                        ?MODULE:loop(Pid);
                %{right} -> 
                %        Pid ! {servo_pos, 4, 500},
                %        ?MODULE:loop(Pid);
                %{left} ->
                %        Pid ! {servo_pos, 4, 2500},
                %        ?MODULE:loop(Pid);
                {Deg} ->
                         Pid ! {servo_pos, 4, Deg},
                         ?MODULE:loop(Pid);
                Any -> io:format('~p got unknown msg: ~p~n', [?MODULE, Any]),
                        ?MODULE:loop(Pid)
        end.
