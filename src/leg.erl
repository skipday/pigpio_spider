-module(leg).
-export([make/1,init/1,loop/2]).
-define(RFMAXFORWARD, 1800).
-define(RFMAXBACK, 800).
-define(RFMAXUP, 1000).
-define(RFMAXDOWN, 500).
-define(LFMAXFORWARD, 1200).
-define(LFMAXBACK, 2000).
-define(LFMAXUP, 1800).
-define(LFMAXDOWN, 1200).

make(Leg) ->
    spawn(?MODULE, init, [Leg]).

init(Leg) ->
    XYPinForwardBack = case Leg of
        left_front_leg -> {27, 17, ?LFMAXBACK, ?LFMAXFORWARD, ?LFMAXDOWN, ?LFMAXUP};
        right_front_leg -> {23, 24, ?RFMAXFORWARD, ?RFMAXBACK, ?RFMAXUP, ?RFMAXDOWN}; % ITS NOT 32, 34
        left_back_leg -> 22;
        right_back_leg -> 23
    end,
    loop(XYPinForwardBack, forward).

loop({XPin, YPin, FAng, BAng, UAng, DAng}, Direction) ->
    receive
        {Pid, move} when Direction == forward ->
            io:format("Forward stroke init"),
            Pid ! {servo_pos, YPin, UAng},
            timer:sleep(250),
            Pid ! {servo_pos, XPin, FAng},
            timer:sleep(250),
            Pid ! {servo_pos, YPin, DAng},
            timer:sleep(250),
            loop({XPin, YPin, FAng, BAng, UAng, DAng}, backward);
        {Pid, move} when Direction == backward -> 
            io:format("Backward stroke init"),
            Pid ! {servo_pos, XPin, BAng},
            timer:sleep(250),
            loop({XPin, YPin, FAng, BAng, UAng, DAng}, forward);
        {Pid, stand} ->
            io:format("standing up"),
            Pid ! {servo_pos, YPin, DAng},
            Pid ! {servo_pos, XPin, round((FAng + BAng) / 2)};
        _Any -> loop({XPin, YPin, FAng, BAng, UAng, DAng}, Direction)
    end.