Using Erlang for GPIO on a raspberry pi with http://abyz.me.uk/rpi/pigpio/

```erlang
% Starting:
{ok, Pid} = conductor:start().
Pid ! { start }. or Pid ! { stop }.
```

## Changelog

### January 6, 2022
- Assembled dev-testing spider version.
- Tried out some servo motor calibration with limited success.
- Wrote some commands to test out moving mulltiple servos.
<img alt="spider sit stand routine" src="https://github.com/skipday/media/blob/main/spider_sit_stand.gif" width=50% height=50%>

### December 30, 2022
- Redesigned the spider body to better fit the Raspberry Pi device.
- Some measurements needs correcting for V.3 but it's solid enough to run walk cycle tests on.
<img alt="spider body v2" src="https://github.com/skipday/media/blob/main/spiderbody_v2.jpeg" width=25% height=25%>

### December 29, 2022
- Designed and printed the first version of the main body for the spider
- Attempted to use AA batteries for the servo motors but encountered issues and had to switch to an external power supply while waiting for new parts
- Improved the walk cycle code to include two legs and set the maximum angles for each leg servo as a constant
- Observed that the angles of the servos seemed to vary slightly each time, possibly due to poor quality of the servos

<img alt="the v1 spider crawls" src="https://github.com/skipday/media/blob/main/spiderbody_v1_crawl.gif" width=25% height=25%>

### December 21, 2022
- Created a test jig using Fusion360 and printed it on a CR-10 3D printer
- Began testing the walking cycle for a single leg

<img alt="spider test jig gif" src="https://github.com/skipday/media/blob/main/spiderleg_testing.gif" width=25% height=25%>
