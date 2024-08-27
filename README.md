# hid-sony

Kernel module for sony playstation controllers. This code comes with [a patch](https://patchwork.kernel.org/patch/10675239/) to fix broken D-Pad for nyko core controllers.
The patch has been submitted to linux input list but not accepted for some time, hence this repo.

## Build, install and reload

```
$ make && sudo make install && sudo make reload
```

## Read raw data from hid device

~~~
# watch -n 0.1 hd -n 49 /dev/hidraw0
~~~
Size value (`-n` parameter) must be:
- 49 bytes for Dualshock 3;
- 78 bytes for Dualshock 4 BT connection;
- 64 bytes for Dualshock 4 USB connection.

## Read events of Dualshock 3

I'm use not original controller, but chinesse copy. It's marked as "CECHZC2U".

Event tree before gamepad connection:

~~~
$ ls /dev/input/
by-path  event0  mice
~~~

Event devices tree after Dualshock 3 BT connection:

~~~
$ ls /dev/input/
by-path  event0  event1  event2  js0  mice
~~~

- `js0` - ps3 gamepad with old driver.
- `event1` - device of 3-axis accelerometer.
- `event2` - main 16-axis gamepad. It has two double axis thumb sticks and 12 buttons with pressure analog sensors.

For testing of event device run command:

~~~
$ evtest /dev/input/event1
~~~

For testing of joystick device run command:

~~~
$ jstest /dev/input/js0
~~~

If you not find `/dev/input/js0` device, run kernel module `joydev`:

~~~
# modprobe joydev
~~~

<details>
  <summary>testing output:</summary>

  ~~~
$ jstest /dev/input/js0
Driver version is 2.1.0.
Joystick (Sony PLAYSTATION(R)3 Controller) has 16 axes (X, Y, Z, Rx, Ry, Rz, Gas, Brake, Hat0X, Hat0Y, Hat1X, Hat1Y, Hat2X, Hat2Y, Hat3X, Hat3Y)
and 17 buttons (BtnA, BtnB, BtnX, BtnY, BtnTL, BtnTR, BtnTL2, BtnTR2, BtnSelect, BtnStart, BtnMode, BtnThumbL, BtnThumbR, (null), (null), (null), (null)).
Testing ... (interrupt to exit)
  ~~~

  ~~~
$ evtest /dev/input/event1
Input driver version is 1.0.1
Input device ID: bus 0x5 vendor 0x54c product 0x268 version 0x8000
Input device name: "Sony PLAYSTATION(R)3 Controller Motion Sensors"
Supported events:
  Event type 0 (EV_SYN)
  Event type 3 (EV_ABS)
    Event code 0 (ABS_X)
      Value    -11
      Min     -512
      Max      511
      Fuzz       4
      Resolution     113
    Event code 1 (ABS_Y)
      Value    274
      Min     -512
      Max      511
      Fuzz       4
      Resolution     113
    Event code 2 (ABS_Z)
      Value    163
      Min     -512
      Max      511
      Fuzz       4
      Resolution     113
Properties:
  Property type 6 (INPUT_PROP_ACCELEROMETER)
Testing ... (interrupt to exit)
  ~~~

  ~~~
Input driver version is 1.0.1
Input device ID: bus 0x5 vendor 0x54c product 0x268 version 0x8000
Input device name: "Sony PLAYSTATION(R)3 Controller"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 304 (BTN_SOUTH)
    Event code 305 (BTN_EAST)
    Event code 307 (BTN_NORTH)
    Event code 308 (BTN_WEST)
    Event code 310 (BTN_TL)
    Event code 311 (BTN_TR)
    Event code 312 (BTN_TL2)
    Event code 313 (BTN_TR2)
    Event code 314 (BTN_SELECT)
    Event code 315 (BTN_START)
    Event code 316 (BTN_MODE)
    Event code 317 (BTN_THUMBL)
    Event code 318 (BTN_THUMBR)
    Event code 544 (BTN_DPAD_UP)
    Event code 545 (BTN_DPAD_DOWN)
    Event code 546 (BTN_DPAD_LEFT)
    Event code 547 (BTN_DPAD_RIGHT)
  Event type 3 (EV_ABS)
    Event code 0 (ABS_X)
      Value    132
      Min        0
      Max      255
      Flat      15
    Event code 1 (ABS_Y)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 2 (ABS_Z)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 3 (ABS_RX)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 4 (ABS_RY)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 5 (ABS_RZ)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 9 (ABS_GAS)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 10 (ABS_BRAKE)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 16 (ABS_HAT0X)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 17 (ABS_HAT0Y)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 18 (ABS_HAT1X)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 19 (ABS_HAT1Y)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 20 (ABS_HAT2X)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 21 (ABS_HAT2Y)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 22 (ABS_HAT3X)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 23 (ABS_HAT3Y)
      Value      0
      Min        0
      Max      255
      Flat      15
  Event type 4 (EV_MSC)
    Event code 4 (MSC_SCAN)
  Event type 21 (EV_FF)
    Event code 80 (FF_RUMBLE)
    Event code 81 (FF_PERIODIC)
    Event code 88 (FF_SQUARE)
    Event code 89 (FF_TRIANGLE)
    Event code 90 (FF_SINE)
    Event code 96 (FF_GAIN)
Properties:
Testing ... (interrupt to exit)
  ~~~
</details>

## Read events of Dualshock 4

I'm use two not original controllers. It's marked as "CUH-ZCT2U" and "CUH-ZCT2E". They has been different PID - `0x09cc` and `0x05c4`.

Event devices tree after Dualshock 3 BT connection:

~~~
$ ls /dev/input/
by-path  event0  event1  event2  event3  js0  mice  mouse0
~~~

- `js0` - ps3 gamepad with old driver.
- `event1` - touchpad
- `event2` - motion sensor. 3-axis accelerometer and 3-axis gyroscope
- `event3` - main 6-axis gamepad with all buttons
- `mouse0` - touchpad as PC mouse

<details>
  <summary>testing output:</summary>

~~~
$ jstest /dev/input/js0
Driver version is 2.1.0.
Joystick (Wireless Controller) has 8 axes (X, Y, Z, Rx, Ry, Rz, Hat0X, Hat0Y)
and 13 buttons (BtnA, BtnB, BtnX, BtnY, BtnTL, BtnTR, BtnTL2, BtnTR2, BtnSelect, BtnStart, BtnMode, BtnThumbL, BtnThumbR).
Testing ... (interrupt to exit)
~~~

~~~
$ evtest /dev/input/event1
Input driver version is 1.0.1
Input device ID: bus 0x5 vendor 0x54c product 0x9cc version 0x8100
Input device name: "Wireless Controller Touchpad"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 272 (BTN_LEFT)
    Event code 325 (BTN_TOOL_FINGER)
    Event code 330 (BTN_TOUCH)
    Event code 333 (BTN_TOOL_DOUBLETAP)
  Event type 3 (EV_ABS)
    Event code 0 (ABS_X)
      Value   1689
      Min        0
      Max     1920
    Event code 1 (ABS_Y)
      Value    518
      Min        0
      Max      942
    Event code 47 (ABS_MT_SLOT)
      Value      0
      Min        0
      Max        1
    Event code 53 (ABS_MT_POSITION_X)
      Value      0
      Min        0
      Max     1920
    Event code 54 (ABS_MT_POSITION_Y)
      Value      0
      Min        0
      Max      942
    Event code 57 (ABS_MT_TRACKING_ID)
      Value      0
      Min        0
      Max    65535
Properties:
  Property type 0 (INPUT_PROP_POINTER)
  Property type 2 (INPUT_PROP_BUTTONPAD)
Testing ... (interrupt to exit)
~~~

~~~
$ evtest /dev/input/event2
Input driver version is 1.0.1
Input device ID: bus 0x5 vendor 0x54c product 0x9cc version 0x8100
Input device name: "Wireless Controller Motion Sensors"
Supported events:
  Event type 0 (EV_SYN)
  Event type 3 (EV_ABS)
    Event code 0 (ABS_X)
      Value    -24
      Min   -32768
      Max    32768
      Fuzz      16
      Resolution    8192
    Event code 1 (ABS_Y)
      Value   7888
      Min   -32768
      Max    32768
      Fuzz      16
      Resolution    8192
    Event code 2 (ABS_Z)
      Value   1537
      Min   -32768
      Max    32768
      Fuzz      16
      Resolution    8192
    Event code 3 (ABS_RX)
      Value   -317
      Min   -2097152
      Max   2097152
      Fuzz      16
      Resolution    1024
    Event code 4 (ABS_RY)
      Value    762
      Min   -2097152
      Max   2097152
      Fuzz      16
      Resolution    1024
    Event code 5 (ABS_RZ)
      Value   -381
      Min   -2097152
      Max   2097152
      Fuzz      16
      Resolution    1024
  Event type 4 (EV_MSC)
    Event code 5 (MSC_TIMESTAMP)
Properties:
  Property type 6 (INPUT_PROP_ACCELEROMETER)
Testing ... (interrupt to exit)
~~~

~~~
$evtest /dev/input/event3
Input driver version is 1.0.1
Input device ID: bus 0x5 vendor 0x54c product 0x9cc version 0x8100
Input device name: "Wireless Controller"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 304 (BTN_SOUTH)
    Event code 305 (BTN_EAST)
    Event code 307 (BTN_NORTH)
    Event code 308 (BTN_WEST)
    Event code 310 (BTN_TL)
    Event code 311 (BTN_TR)
    Event code 312 (BTN_TL2)
    Event code 313 (BTN_TR2)
    Event code 314 (BTN_SELECT)
    Event code 315 (BTN_START)
    Event code 316 (BTN_MODE)
    Event code 317 (BTN_THUMBL)
    Event code 318 (BTN_THUMBR)
  Event type 3 (EV_ABS)
    Event code 0 (ABS_X)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 1 (ABS_Y)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 2 (ABS_Z)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 3 (ABS_RX)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 4 (ABS_RY)
      Value    128
      Min        0
      Max      255
      Flat      15
    Event code 5 (ABS_RZ)
      Value      0
      Min        0
      Max      255
      Flat      15
    Event code 16 (ABS_HAT0X)
      Value      0
      Min       -1
      Max        1
    Event code 17 (ABS_HAT0Y)
      Value      0
      Min       -1
      Max        1
  Event type 4 (EV_MSC)
    Event code 4 (MSC_SCAN)
  Event type 21 (EV_FF)
    Event code 80 (FF_RUMBLE)
    Event code 81 (FF_PERIODIC)
    Event code 88 (FF_SQUARE)
    Event code 89 (FF_TRIANGLE)
    Event code 90 (FF_SINE)
    Event code 96 (FF_GAIN)
Properties:
Testing ... (interrupt to exit)
~~~
</details>