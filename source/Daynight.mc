using Toybox.Graphics;
using Toybox.Math;
using Toybox.Position;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Weather;


import Toybox.Lang;


class Daynight {

    private static const DEFAULT_LATTITUDE = 47.3299;
    private static const DEFAULT_LONGITUDE = 8.6240;

    private static const DEFAULT_SUNRISE_MOMENT = Time.now();
    private static const DEFAULT_SUNSET_MOMENT = DEFAULT_SUNRISE_MOMENT;

    private static const DEFAULT_DAY_COLOR = 0xFF9500;
    private static const DEFAULT_NIGHT_COLOR = 0x007AFF;
    private static const DEFAULT_TWILIGHT_COLOR = Graphics.COLOR_ORANGE;
    private static const DEFAULT_TEXT_COLOR = Graphics.COLOR_WHITE;

    private static const DEFAULT_RADIUS_FACTOR = 0.9;
    private static const DEFAULT_THICKNESS_FACTOR = 0.1;

    private static const DEFAULT_GREETING_TEXT = "Good";
    private static const DEFAULT_MORNING_TEXT = "morning";
    private static const DEFAULT_AFTERNOON_TEXT = "afternoon";
    private static const DEFAULT_EVENING_TEXT = "evening";
    private static const DEFAULT_NIGHT_TEXT = "night";
    private static const DEFAULT_ADDRESS_TEXT = "Dear";
    

    private var _latitude as Float = DEFAULT_LATTITUDE;
    private var _longitude as Float = DEFAULT_LONGITUDE;
    private var _location as Position.Location;

    // private var _dawnMoment as Time.Moment;
    private var _sunriseMoment as Time.Moment = DEFAULT_SUNRISE_MOMENT;
    private var _sunsetMoment as Time.Moment = DEFAULT_SUNSET_MOMENT;
    // private var _duskMoment as Time.Moment;

    private var _dayColor as Graphics.ColorType = DEFAULT_DAY_COLOR;
    private var _nightColor as Graphics.ColorType = DEFAULT_NIGHT_COLOR;
    // private var _twilightColor as Graphics.ColorType = DEFAULT_TWILIGHT_COLOR;

    private var _clock as System.ClockTime = System.getClockTime();

    function initialize() {
        _location = new Position.Location({
            :latitude => DEFAULT_LATTITUDE,
            :longitude => DEFAULT_LONGITUDE,
            :format => :degrees
        });
        _refershLocation();
        _refreshSunData();
    }

    private function _refershLocation() as Daynight {
        // var position_info = Position.getInfo();
        // if (position_info has :position && position_info.position != null) {
        //     _location = position_info.position;
        // }
        return self;
    }

    private function _refreshSunData() as Daynight {
        var today = Time.today(); // Midnight today
        if (Weather has :getSunrise) {
            _sunriseMoment = Weather.getSunrise(_location, today);
            _sunsetMoment = Weather.getSunset(_location, today);
            // _dawnMoment = Weather.getDawn(_location, today);
            // _duskMoment = Weather.getDusk(_location, today);
        }
        return self;
    }


    function withDayColor(dayColor as Graphics.ColorType) as Daynight {
        _dayColor = dayColor;
        return self;
    }

    function withNightColor(nightColor as Graphics.ColorType) as Daynight {
        _nightColor = nightColor;
        return self;
    }

    // function withTwilightColor(twilightColor as Graphics.ColorType) as Daynight {
    //     _twilightColor = twilightColor;
    //     return self;
    // }


    function forTime(time as System.ClockTime) as Daynight {
        _clock = time;
        return self;
    }

    function draw(dc as Graphics.Dc) as Daynight {

        _refershLocation();
        _refreshSunData();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        var radius = (DEFAULT_RADIUS_FACTOR * ((width < height) ? width : height) / 2).toNumber();

        var sunriseInfo = Gregorian.info(_sunriseMoment, Time.FORMAT_SHORT);
        var sunriseHour = sunriseInfo.hour;
        var sunriseMinute = sunriseInfo.min;

        var sunsetInfo = Gregorian.info(_sunsetMoment, Time.FORMAT_SHORT);
        var sunsetHour = sunsetInfo.hour;
        var sunsetMinute = sunsetInfo.min;

        var dayStartAngle = _timeToAngle(sunriseHour, sunriseMinute);
        var dayEndAngle = _timeToAngle(sunsetHour, sunsetMinute);
        var nightStartAngle = dayEndAngle;
        var nightEndAngle = dayStartAngle;

        dc.setPenWidth((DEFAULT_THICKNESS_FACTOR * radius).toNumber());
        dc.setColor(_dayColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, dayStartAngle, dayEndAngle);
        dc.setColor(_nightColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, nightStartAngle, nightEndAngle);

        var currentHour = _clock.hour;
        var currentMinute = _clock.min;

        var currentTimeAngle = _timeToAngle(currentHour, currentMinute);
        var sunCoordinates = _toCartesian((0.8 * radius).toNumber(), currentTimeAngle);

        var sunriseMinutes = sunriseHour * 60 + sunriseMinute;
        var sunsetMinutes = sunsetHour * 60 + sunsetMinute;
        var currentTimeMinutes = currentHour * 60 + currentMinute;

        var noonMinutes = 12 * 60;
        var midnightMinutes = 0;

        var text = "";

        if (currentTimeMinutes < sunriseMinutes) {
            text = DEFAULT_NIGHT_TEXT;
            dc.setColor(DEFAULT_NIGHT_COLOR, Graphics.COLOR_TRANSPARENT);
        } else if (currentTimeMinutes >= sunriseMinutes and currentTimeMinutes <= noonMinutes) {
            text = DEFAULT_MORNING_TEXT;
            dc.setColor(DEFAULT_DAY_COLOR, Graphics.COLOR_TRANSPARENT);
        } else if (currentTimeMinutes > noonMinutes and currentTimeMinutes <= sunsetMinutes) {
            text = DEFAULT_AFTERNOON_TEXT;
            dc.setColor(DEFAULT_DAY_COLOR, Graphics.COLOR_TRANSPARENT);
        } else if (currentTimeMinutes > sunsetMinutes and currentTimeMinutes < midnightMinutes) {
            text = DEFAULT_EVENING_TEXT;
            dc.setColor(DEFAULT_NIGHT_COLOR, Graphics.COLOR_TRANSPARENT);
        }

        dc.fillCircle(centerX + sunCoordinates[0], centerY + sunCoordinates[1], DEFAULT_THICKNESS_FACTOR * radius);
        
        dc.setColor(DEFAULT_TEXT_COLOR, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY, Graphics.FONT_MEDIUM, text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        return self;
    }

    private function _timeToAngle(hour as Number, minutes as Number) as Number {
        return 270 - ((1.0 * hour * 60 + minutes) / (24 * 60) * 360).toNumber();
    }

    private function _toCartesian(radius as Number, angle as Number) as [Number, Number] {
        var angleRadians = Math.toRadians(angle);
        return [
            (radius * Math.cos(angleRadians)).toNumber(),
            (-1.0 * radius * Math.sin(angleRadians)).toNumber()
        ];
    }

    private function _isBefore(this as Dictionary, that as Dictionary) as Boolean {
        return (this[:hour] * 60 + this[:min]) < (that[:hour] * 60 + that[:min]);
    }

    private function _isAfter(this as Dictionary, that as Dictionary) as Boolean {
        return (this[:hour] * 60 + this[:min]) > (that[:hour] * 60 + that[:min]);
    }

}