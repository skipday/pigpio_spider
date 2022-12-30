Using Erlang for GPIO on a raspberry pi with http://abyz.me.uk/rpi/pigpio/

```erlang
% Starting:
{ok, Pid} = conductor:start().
Pid ! { start }. or Pid ! { stop }.
```

## Changelog

### December 30, 2022
- Redesigned the spider body to better fit the Raspberry Pi device.

![Spider body with improved design](https://example.com/spider-body-2.gif)

### December 29, 2022
- Designed and printed the first version of the main body for the spider
- Attempted to use AA batteries for the servo motors but encountered issues and had to switch to an external power supply while waiting for new parts
- Improved the walk cycle code to include two legs and set the maximum angles for each leg servo as a constant
- Observed that the angles of the servos seemed to vary slightly each time, possibly due to poor quality of the servos

<img style="display: block; 
     margin-left: auto;
     margin-right: auto;
     src="https://github.com/skipday/media/blob/main/spiderbody_v1_crawl.gif" width=25% height=25%>

### December 21, 2022
- Created a test jig using Fusion360 and printed it on a CR-10 3D printer
- Began testing the walking cycle for a single leg

<img style="display: block; 
     margin-left: auto;
     margin-right: auto;
     src="https://github.com/skipday/media/blob/main/spiderleg_testing.gif" width=25% height=25%>
