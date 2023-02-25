-module(conductor).
-export([start/0, init/0, loop/7]).

start() ->
    MasterPid = spawn_link(?MODULE, init, []),
    {ok, MasterPid}.

init() ->
    io:format("New process: ~p~n", [?MODULE]),
    {ok, Pid} = pigpio:start(),
    Pid ! {setmode, 4, 1},
    Leg1 = leg:make(left_front_leg),
    % Bortkommenterat, det finns ju bara 1 ben ännu så länge.
    Leg2 = leg:make(right_front_leg),
    Leg3 = leg:make(left_back_leg),
    Leg4 = leg:make(right_back_leg),

    % Ett meddelande per sekund sänds till self() denna process
    timer:send_interval(500, {left_front_leg}),
    timer:sleep(250),
    timer:send_interval(500, {right_front_leg}),
    timer:sleep(250),
    timer:send_interval(500, {right_back_leg}),
    timer:sleep(250),
    timer:send_interval(500, {left_back_leg}),
    %        timer:sleep(100),                           % Du har ju inte leg2 ännu men här kan man alltså
    %        timer:send_interval(10000,{left back leg}), % ställa in tiden mellan t ex framben och bakben rör sig.
    %        timer:send_interval(10000,{right back leg}),% Här finns ingen timer:sleep() emellan, då får båda benen message samtidigt.

    % I stället för infinity kan man skriva önskad timeout i millisekunder.
    loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, infinity).
% Då stannar spindeln även om man inte skriver kommando stop.

loop(Pid, Leg1, Leg2, Leg3, Leg4, Status, Timeout) ->
    receive
        % start och stop ändrar bara värdet på variabeln Status
        {start} ->
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, go, Timeout);
        {stop} ->
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, Timeout);
        % {stand} ->
        %     Leg1 ! {Pid, up},
        %     Leg2 ! {Pid, up},
        %     Leg3 ! {Pid, up},
        %     Leg4 ! {Pid, up},
        %     ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, Timeout);
        % {sit} ->
        %     Leg1 ! {Pid, down},
        %     Leg2 ! {Pid, down},
        %     Leg3 ! {Pid, up},
        %     Leg4 ! {Pid, up},
        %     ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, Timeout);
        % {crouch} ->
        %     Leg1 ! {Pid, up},
        %     Leg2 ! {Pid, up},
        %     Leg3 ! {Pid, down},
        %     Leg4 ! {Pid, down},
        %     ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, Timeout);
        % {look} ->
        %     Leg1 ! {Pid, down},
        %     Leg2 ! {Pid, down},
        %     Leg3 ! {Pid, down},
        %     Leg4 ! {Pid, down},
        %     ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, Timeout);
        % {Pin, Angle} ->
        %     Pid ! {servo_pos, Pin, Angle},
        %     ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, Timeout);
        % Meddelande skickas till benet om variabeln Status = go
        {left_front_leg} when Status == go ->
            Leg1 ! {Pid, move},
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, Status, Timeout);
        {right_front_leg} when Status == go ->
            Leg2 ! {Pid, move},
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, Status, Timeout);
        {left_back_leg} when Status == go ->
            Leg3 ! {Pid, move},
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, Status, Timeout);
        {right_back_leg} when Status == go ->
            Leg4 ! {Pid, move},
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, Status, Timeout);
        %io:format("~p got unknown msg: ~p~n",[?MODULE, Any]),
        _Any ->
            ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, Status, Timeout)
    after Timeout ->
        ?MODULE:loop(Pid, Leg1, Leg2, Leg3, Leg4, stop, infinity)
    end.
