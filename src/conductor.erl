-module(conductor).
-export([start/0,init/0,loop/7]).

start() -> MasterPid = spawn_link(?MODULE,init,[]), {ok,MasterPid}.

init() ->
    io:format("New process: ~p~n", [?MODULE]),
    {ok, Pid} = pigpio:start(),
    Pid ! {setmode, 4, 1},
    Leg1 = leg:make(left_front_leg),
    Leg2 = leg:make(right_front_leg), % Bortkommenterat, det finns ju bara 1 ben ännu så länge.
%        Leg3 = leg:make(left back leg),
%        Leg4 = leg:make(right back leg),
    timer:send_interval(500,{left_front_leg}),  % Ett meddelande per sekund sänds till self() denna process
    timer:sleep(125),
    timer:send_interval(500,{right_front_leg}),
%        timer:sleep(100),                           % Du har ju inte leg2 ännu men här kan man alltså
%        timer:send_interval(10000,{left back leg}), % ställa in tiden mellan t ex framben och bakben rör sig.
%        timer:send_interval(10000,{right back leg}),% Här finns ingen timer:sleep() emellan, då får båda benen message samtidigt.
    loop(Pid, Leg1, Leg2, Leg1, Leg1, stop, infinity). % I stället för infinity kan man skriva önskad timeout i millisekunder.
        % Då stannar spindeln även om man inte skriver kommando stop.

loop(Pid, Leg1,Leg2, Leg3, Leg4, Status, Timeout) ->
    receive
        {start} -> ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,go,Timeout);  % start och stop ändrar bara värdet på variabeln Status
        {stop}  -> ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,stop,Timeout);
        {stand} -> 
            Leg1 ! {Pid, stand},
            Leg2 ! {Pid, stand},
            %Leg3 ! {Pid, stand},
            %Leg4 ! {Pid, stand},
            ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,stop,Timeout);
        {Pin, Angle} -> Pid ! {servo_pos, Pin, Angle}, ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,stop,Timeout);
        {left_front_leg} when Status == go -> Leg1 ! {Pid, move},   % Meddelande skickas till benet om variabeln Status = go
    ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,Status,Timeout);
        {right_front_leg} when Status == go -> Leg2 ! {Pid, move},
    ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,Status,Timeout);

        _Any -> %io:format("~p got unknown msg: ~p~n",[?MODULE, Any]),
    ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,Status,Timeout)
        
    after Timeout ->
        ?MODULE:loop(Pid, Leg1,Leg2,Leg3,Leg4,stop,infinity)
    end.