using Toybox.Application;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Position;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Weather;

import Toybox.Lang;

using Constants as CS;


class Daynight {

    private static const DEFAULT_TEXT_FONT = Application.loadResource(Rez.Fonts.DefaultFont);
    private static const DEFAULT_DAYNIGHT_FONT = Application.loadResource(Rez.Fonts.DaynightFont);

    private static const DEFAULT_LATTITUDE = 47.3299;
    private static const DEFAULT_LONGITUDE = 8.6240;

    private static const DEFAULT_SUNRISE_MOMENT = Time.now();
    private static const DEFAULT_SUNSET_MOMENT = DEFAULT_SUNRISE_MOMENT;

    private static const DEFAULT_MORNING_COLOR = Graphics.COLOR_ORANGE;
    private static const DEFAULT_DAY_COLOR = 0xFF9500;
    private static const DEFAULT_AFTERNOON_COLOR = DEFAULT_DAY_COLOR;
    private static const DEFAULT_EVENING_COLOR = Graphics.COLOR_RED;
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
    private static const DEFAULT_ADDRESS_TEXT = "Dear!";

    private static const DEFAULT_VERTICAL_TEXT_SHIFT_FACTOR = 0.75;
    

    private var _location as Position.Location;

    // private var _dawnMoment as Time.Moment;
    private var _sunriseMoment as Time.Moment = DEFAULT_SUNRISE_MOMENT;
    private var _sunsetMoment as Time.Moment = DEFAULT_SUNSET_MOMENT;
    // private var _duskMoment as Time.Moment;

    private var _dayColor as Graphics.ColorType = DEFAULT_DAY_COLOR;
    private var _nightColor as Graphics.ColorType = DEFAULT_NIGHT_COLOR;
    // private var _twilightColor as Graphics.ColorType = DEFAULT_TWILIGHT_COLOR;

    private var _time as System.ClockTime = System.getClockTime();

    function initialize() {
        _location = new Position.Location({
            :latitude => DEFAULT_LATTITUDE,
            :longitude => DEFAULT_LONGITUDE,
            :format => :degrees
        });
        _refershLocation(); // disable for simulation
        _refreshSunData();
    }

    private function _refershLocation() as Daynight {
        var position_info = Position.getInfo();
        if (position_info has :position && position_info.position != null) {
            _location = position_info.position;
        }
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
        _time = time;
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

        var currentHour = _time.hour;
        var currentMinute = _time.min;

        var currentTimeAngle = _timeToAngle(currentHour, currentMinute);
        var sunCoordinates = _toCartesian((0.8 * radius).toNumber(), currentTimeAngle);

        var sunriseMinutes = sunriseHour * 60 + sunriseMinute;
        var sunsetMinutes = sunsetHour * 60 + sunsetMinute;
        var currentMinutes = currentHour * 60 + currentMinute;

        var noonMinutes = 12 * 60;
        var eveningMinutes = 22 * 60;
        // var midnightMinutes = 23 * 60 + 59;

        var greeting = "day";
        var greetingColor = DEFAULT_TEXT_COLOR;
        var sunColor = DEFAULT_TWILIGHT_COLOR;

        if (currentMinutes < sunriseMinutes or currentMinutes >= eveningMinutes) {
            greeting = DEFAULT_NIGHT_TEXT;
            greetingColor = DEFAULT_NIGHT_COLOR;
            sunColor = DEFAULT_NIGHT_COLOR;
        } else if (currentMinutes >= sunriseMinutes and currentMinutes <= noonMinutes) {
            greeting = DEFAULT_MORNING_TEXT;
            greetingColor = DEFAULT_MORNING_COLOR;
            sunColor = DEFAULT_DAY_COLOR;
        } else if (currentMinutes > noonMinutes and currentMinutes <= sunsetMinutes) {
            greeting = DEFAULT_AFTERNOON_TEXT;
            greetingColor = DEFAULT_AFTERNOON_COLOR;
            sunColor = DEFAULT_DAY_COLOR;
        } else if (currentMinutes > sunsetMinutes and currentMinutes < eveningMinutes) {
            greeting = DEFAULT_EVENING_TEXT;
            greetingColor = DEFAULT_EVENING_COLOR;
            sunColor = DEFAULT_NIGHT_COLOR;
        }

        var sunColorIndex = PropertyUtils.getPropertyElseDefault(CS.SUN_COLOR_PROPERTY_ID, CS.SUN_COLOR_PROPERTY_DEFAULT);
        if (sunColorIndex == 1) { // sun color = greeting color
            sunColor = greetingColor;
        }
        
        dc.setColor(sunColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX + sunCoordinates[0], centerY + sunCoordinates[1], DEFAULT_THICKNESS_FACTOR * radius);
        
        var daynightDimensions = dc.getTextDimensions(greeting, DEFAULT_DAYNIGHT_FONT);
        var daynightWidth = daynightDimensions[0];
        var daynightHeight = daynightDimensions[1];
        var verticalShift = DEFAULT_VERTICAL_TEXT_SHIFT_FACTOR * daynightHeight;
        var daynightX = centerX - daynightWidth / 2;

        dc.setColor(DEFAULT_TEXT_COLOR, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - verticalShift, DEFAULT_TEXT_FONT, DEFAULT_GREETING_TEXT, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(centerX, centerY + verticalShift, DEFAULT_TEXT_FONT, DEFAULT_ADDRESS_TEXT, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(daynightX + daynightWidth, centerY, DEFAULT_DAYNIGHT_FONT, ",", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(greetingColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(daynightX, centerY, DEFAULT_DAYNIGHT_FONT, greeting, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

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