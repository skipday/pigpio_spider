-module(leg).
-export([make/1, init/1, loop/2]).
-define(RFMAXFORWARD, 1800).
-define(RFMAXBACK, 800).
-define(RFMAXUP, 2000).
-define(RFMAXDOWN, 1200).
-define(LFMAXFORWARD, 1200).
-define(LFMAXBACK, 2000).
-define(LFMAXUP, 1800).
-define(LFMAXDOWN, 1200).

-define(COMMONMAXDOWN, 1200).
-define(COMMONMAXUP, 2000).

make(Leg) ->
    spawn(?MODULE, init, [Leg]).

init(Leg) ->
    XYPinForwardBack =
        case Leg of
            left_front_leg -> {17, 27, ?LFMAXBACK, ?LFMAXFORWARD, ?COMMONMAXUP, ?COMMONMAXDOWN};
            right_front_leg -> {23, 24, ?RFMAXFORWARD, ?RFMAXBACK, ?COMMONMAXUP, ?COMMONMAXDOWN};
            left_back_leg -> {26, 19, ?RFMAXFORWARD, ?RFMAXBACK, ?COMMONMAXUP, ?COMMONMAXDOWN};
            right_back_leg -> {21, 20, ?RFMAXFORWARD, ?RFMAXBACK, ?COMMONMAXUP, ?COMMONMAXDOWN}
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
        {Pid, up} ->
            io:format("standing up"),
            Pid ! {servo_pos, YPin, DAng},
            loop({XPin, YPin, FAng, BAng, UAng, DAng}, Direction);
        {Pid, down} ->
            io:format("sitting down"),
            Pid ! {servo_pos, YPin, 1600},
            loop({XPin, YPin, FAng, BAng, UAng, DAng}, Direction);
        _Any ->
            loop({XPin, YPin, FAng, BAng, UAng, DAng}, Direction)
    end.
