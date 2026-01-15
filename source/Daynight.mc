using Toybox.Application;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Position;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;
using Toybox.Weather;

import Toybox.Lang;

using Constants as CS;


class Daynight {

    private enum GreetingTime {
        MORNING_GREETING_TIME,
        DAY_GREETING_TIME,
        AFTERNOON_GREETING_TIME,
        EVENING_GREETING_TIME,
        NIGHT_GREETING_TIME
    }

    private static const 
        DEFAULT_TEXT_FONT = Application.loadResource(Rez.Fonts.DefaultFont),
        DEFAULT_DAYNIGHT_FONT = Application.loadResource(Rez.Fonts.DaynightFont);

    private static const 
        DEFAULT_LATTITUDE = 47.3299,
        DEFAULT_LONGITUDE = 8.6240;

    private static const 
        ONE_HOUR_DURATION = new Time.Duration(1 * 3600),
        SIX_HOURS_DURATION = new Time.Duration(6 * 3600),
        TWELVE_HOURS_DURATION = new Time.Duration(12 * 3600);

    private static const 
        DEFAULT_MIDNIGHT_MOMENT = Time.today(),
        DEFAULT_MORNING_MOMENT = DEFAULT_MIDNIGHT_MOMENT.add(SIX_HOURS_DURATION),
        DEFAULT_NOON_MOMENT = DEFAULT_MORNING_MOMENT.add(SIX_HOURS_DURATION),
        DEFAULT_EVENING_MOMENT = DEFAULT_NOON_MOMENT.add(SIX_HOURS_DURATION),
        DEFAULT_SUNRISE_MOMENT = DEFAULT_MORNING_MOMENT,
        DEFAULT_SUNSET_MOMENT = DEFAULT_EVENING_MOMENT,
        DEFAULT_DAWN_MOMENT = DEFAULT_SUNRISE_MOMENT.subtract(ONE_HOUR_DURATION),
        DEFAULT_DUSK_MOMENT = DEFAULT_SUNSET_MOMENT.add(ONE_HOUR_DURATION);


    private static const 
        DEFAULT_MORNING_COLOR = Graphics.COLOR_ORANGE,
        DEFAULT_DAY_COLOR = 0xFF9500,
        DEFAULT_AFTERNOON_COLOR = DEFAULT_DAY_COLOR,
        DEFAULT_EVENING_COLOR = Graphics.COLOR_RED,
        DEFAULT_NIGHT_COLOR = 0x007AFF,
        DEFAULT_TWILIGHT_COLOR = Graphics.COLOR_ORANGE,
        DEFAULT_TEXT_COLOR = Graphics.COLOR_WHITE;

    private static const 
        DEFAULT_RADIUS_FACTOR = 0.9,
        DEFAULT_THICKNESS_FACTOR = 0.1,
        DEFAULT_GAP_ANGLE = 1,
        DEFAULT_TWILIGHT_ANGLE = 8,
        DEFAULT_VERTICAL_TEXT_SHIFT_FACTOR = 0.75;

    // TODO load from resources
    private static const 
        DEFAULT_GREETING_TEXT = Application.loadResource(Rez.Strings.Greeting),
        DEFAULT_DAY_TEXT = Application.loadResource(Rez.Strings.Day),
        DEFAULT_MORNING_TEXT = Application.loadResource(Rez.Strings.Morning),
        DEFAULT_AFTERNOON_TEXT = Application.loadResource(Rez.Strings.Afternoon),
        DEFAULT_EVENING_TEXT = Application.loadResource(Rez.Strings.Evening),
        DEFAULT_NIGHT_TEXT = Application.loadResource(Rez.Strings.Night),
        DEFAULT_ADDRESS_TEXT = Application.loadResource(Rez.Strings.Invocation);


    private var _location as Position.Location;

    private var 
        _midnight = DEFAULT_MIDNIGHT_MOMENT,
        _dawn = DEFAULT_DAWN_MOMENT,
        _sunrise  = DEFAULT_SUNRISE_MOMENT,
        _morning = DEFAULT_MORNING_MOMENT,
        _noon = DEFAULT_NOON_MOMENT,
        _evening = DEFAULT_EVENING_MOMENT,
        _sunset = DEFAULT_SUNSET_MOMENT,
        _dusk = DEFAULT_DUSK_MOMENT;

    private var 
        _dayColor as Graphics.ColorType = DEFAULT_DAY_COLOR,
        _nightColor as Graphics.ColorType = DEFAULT_NIGHT_COLOR,
        _twilightColor as Graphics.ColorType = DEFAULT_TWILIGHT_COLOR;

    private var _time as Time.Moment = Time.now();


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
        if (!CS.IS_SIMULATOR_BUILD) {
            var position_info = Position.getInfo();
            if (position_info has :position && position_info.position != null) {
                _location = position_info.position;
            }
        }
        return self;
    }


    private function _refreshSunData() as Daynight {
        _midnight = Time.today();
        if (Weather has :getSunrise) {
            _noon = _midnight.add(TWELVE_HOURS_DURATION);
            _sunrise = Weather.getSunrise(_location, _midnight);
            _sunset = Weather.getSunset(_location, _midnight);
            _dawn = _sunrise.subtract(ONE_HOUR_DURATION);
            _dusk = _sunset.add(ONE_HOUR_DURATION);
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


    function withTwilightColor(twilightColor as Graphics.ColorType) as Daynight {
        _twilightColor = twilightColor;
        return self;
    }


    function forTime(time as Time.Moment) as Daynight {
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

        var angleCorrection = DEFAULT_GAP_ANGLE + DEFAULT_TWILIGHT_ANGLE / 2;
        var dayStartAngle = _timeToAngle(_sunrise) - angleCorrection;
        var dayEndAngle = _timeToAngle(_sunset) + angleCorrection;
        var nightStartAngle = dayEndAngle - angleCorrection;
        var nightEndAngle = dayStartAngle + angleCorrection;

        dc.setPenWidth((DEFAULT_THICKNESS_FACTOR * radius).toNumber());
        
        dc.setColor(_dayColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, dayStartAngle, dayEndAngle);
        
        dc.setColor(_nightColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, nightStartAngle, nightEndAngle);

        dc.setColor(_twilightColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, dayEndAngle - DEFAULT_GAP_ANGLE, nightStartAngle + DEFAULT_GAP_ANGLE);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, nightEndAngle - DEFAULT_GAP_ANGLE, dayStartAngle + DEFAULT_GAP_ANGLE);

        var currentTimeAngle = _timeToAngle(_time);
        var sunCoordinates = _toCartesian((0.8 * radius).toNumber(), currentTimeAngle);

        var greeting = DEFAULT_DAY_TEXT;
        var greetingColor = DEFAULT_TEXT_COLOR;
        var greetingType = _scheduleBasedGreeting();
        switch (greetingType) {
            case MORNING_GREETING_TIME:
                greeting = DEFAULT_MORNING_TEXT;
                greetingColor = DEFAULT_MORNING_COLOR;
                break;
            case AFTERNOON_GREETING_TIME:
                greeting = DEFAULT_AFTERNOON_TEXT;
                greetingColor = DEFAULT_AFTERNOON_COLOR;
                break;
            case EVENING_GREETING_TIME:
                greeting = DEFAULT_EVENING_TEXT;
                greetingColor = DEFAULT_EVENING_COLOR;
                break;
            case NIGHT_GREETING_TIME:
                greeting = DEFAULT_NIGHT_TEXT;
                greetingColor = DEFAULT_NIGHT_COLOR;
                break;
        }

        var sunColor = _twilightColor;
        if (_time.lessThan(_dawn)) {
            sunColor = _nightColor;
        } else if (_time.lessThan(_sunrise)) {
            sunColor = _twilightColor;
        } else if (_time.lessThan(_sunset)) {
            sunColor = _dayColor;
        } else if (_time.lessThan(_dusk)) {
            sunColor = _twilightColor;
        } else {
            sunColor = DEFAULT_NIGHT_COLOR;
        }

        var sunColorOption = PropertyUtils.getPropertyElseDefault(CS.SUN_COLOR_PROPERTY_ID, CS.SUN_COLOR_PROPERTY_DEFAULT);
        if (sunColorOption == 1) { // sun color = greeting color
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


    private function _timeToAngle(time as Time.Moment) as Number {
        var info = Gregorian.info(time, Time.FORMAT_SHORT);
        return 270 - ((info.hour * 60.0 + info.min) / (24 * 60) * 360).toNumber();
    }


    private function _toCartesian(radius as Number, angle as Number) as [Number, Number] {
        var angleRadians = Math.toRadians(angle);
        return [
            (radius * Math.cos(angleRadians)).toNumber(),
            - (radius * Math.sin(angleRadians)).toNumber()
        ];
    }


    // Hardcoded greeting times
    private function _fixedTimeGreeting() as GreetingTime {        
        return _timeBasedGreeting(_morning, _noon, _evening, _midnight);
    }


    // In-app customisation user defined greeting times
    private function _userSettingGreeting() as GreetingTime {
        // TODO
        return DAY_GREETING_TIME;
    }


    // Daynight-adaptive greeting times based on sunrise and sunset times
    private function _daynightGreeting() as GreetingTime {
        var morning = _sunrise;
        var day = _noon;
        var evening = _sunset;
        var night = _midnight;
        return _timeBasedGreeting(morning, day, evening, night);
    }


    // Schedule-dependent greeting times based on user profile settings
    private function _scheduleBasedGreeting() as GreetingTime {
        var morning = _getWakeTime();
        var day = Time.today().add(TWELVE_HOURS_DURATION);
        var evening = _sunset;
        var night = _getSleepTime();
        return _timeBasedGreeting(morning, day, evening, night);
    }


    // Activity-dependent greeting times
    // private function _activityBasedGreeting() as GreetingTime {
    //     // TODO
    //     return DAY_GREETING_TIME;
    // }

    private function _timeBasedGreeting(morning as Time.Moment, day as Time.Moment, evening as Time.Moment, night as Time.Moment) as GreetingTime {

        if (day.lessThan(morning)) {
            day = morning.add(ONE_HOUR_DURATION);
        }
        if (evening.lessThan(day)) {
            evening = day.add(ONE_HOUR_DURATION);
        }
        if (night.lessThan(evening)) {
            night = evening.add(ONE_HOUR_DURATION);
        }

        if (_time.lessThan(morning)) {
            return NIGHT_GREETING_TIME;
        } else if (_time.lessThan(day)) {
            return MORNING_GREETING_TIME;
        } else if (_time.lessThan(evening)) {
            return AFTERNOON_GREETING_TIME;
        } else if (_time.lessThan(night)) {
            return EVENING_GREETING_TIME;
        } else {
            return NIGHT_GREETING_TIME;
        }
        
    }


    private function _getWakeTime() as Time.Moment {
        var profile = UserProfile.getProfile();
        if (profile has :wakeTime && profile.wakeTime != null) {
            return Time.today().add(profile.wakeTime);
        }
        return _morning;
    }


    private function _getSleepTime() as Time.Moment {
        var profile = UserProfile.getProfile();
        if (profile has :sleepTime && profile.sleepTime != null) {
            return Time.today().add(profile.sleepTime);
        }
        return _midnight;
    }


}
