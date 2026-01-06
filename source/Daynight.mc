using Toybox.Graphics;
using Toybox.System;

import Toybox.Lang;


class Daynight {

    private static const DEFAULT_DAY_COLOR = Graphics.COLOR_ORANGE;
    private static const DEFAULT_NIGHT_COLOR = Graphics.COLOR_BLUE;

    private static const DEFAULT_RADIUS_FACTOR = 0.8;

    private var _dayColor as Graphics.ColorType = DEFAULT_DAY_COLOR;
    private var _nightColor as Graphics.ColorType = DEFAULT_NIGHT_COLOR;

    private var _clock as System.ClockTime = System.getClockTime();

    function initialize() {
    }

    function withDayColor(dayColor as Graphics.ColorType) as Daynight {
        _dayColor = dayColor;
        return self;
    }

    function withNightColor(nightColor as Graphics.ColorType) as Daynight {
        _nightColor = nightColor;
        return self;
    }

    function forTime(time as System.ClockTime) as Daynight {
        _clock = time;
        return self;
    }

    function draw(dc as Graphics.Dc) as Daynight {

        var width = dc.getWidth();
        var height = dc.getHeight();

        var centerX = width / 2;
        var centerY = height / 2;

        var radius = (DEFAULT_RADIUS_FACTOR * ((width < height) ? width : height) / 2).toNumber();
 

        return self;
    }

}