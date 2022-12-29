-module(servotest).
-author(ama).
-export([start/0,init/0,loop/1]).
-define(UINT,32/little).
-import(timer, [wait/1]).

start() -> Pid = spawn_link(?MODULE,init,[]), {ok,Pid}.

init() ->
        {ok, Pid} = pigpio:start(),
        Pid ! {setmode, 4, 1},
        self() ! {center},
        loop(Pid).



loop(Pid) ->
        receive
                {stop} -> 
                        io:format("Received stop message, exiting loop~n"),
                        ok;
                {start} -> 
                        io:format("Received start message, starting loop back up~n"),
                        ?MODULE:loop(Pid);
                {center} -> 
                        Pid ! {servo_pos, 27, 1500},
                        ?MODULE:loop(Pid);
                {fw, Time} -> 
                        Pid ! {servo_pos, 17, 1600},
                        timer:sleep(Time),
                        Pid ! {servo_pos, 27, 1900},
                        timer:sleep(Time),
                        Pid ! {servo_pos, 17, 1300},
                        self() ! {bk, 150},
                        timer:sleep(500),
                        ?MODULE:loop(Pid);
                {bk, Time} -> 
                        Pid ! {servo_pos, 17, 1600},
                        timer:sleep(Time),
                        Pid ! {servo_pos, 27, 1000},
                        timer:sleep(Time),
                        Pid ! {servo_pos, 17, 1300},
                        self() ! {fw, 150},
                        timer:sleep(500),
                        ?MODULE:loop(Pid);
                {right} -> 
                        Pid ! {servo_pos, 27, 500},
                        ?MODULE:loop(Pid);
                {left} ->
                        Pid ! {servo_pos, 27, 1500},
                        ?MODULE:loop(Pid);
                {Deg, Pin} ->
                         Pid ! {servo_pos, Pin, Deg},
                         ?MODULE:loop(Pid);
                Any -> io:format('~p got unknown msg: ~p~n', [?MODULE, Any]),
                        ?MODULE:loop(Pid)
        end.