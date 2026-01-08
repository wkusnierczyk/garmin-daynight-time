using Toybox.Application;

import Toybox.Lang;


module Constants {

    (:debug)
    const IS_DEBUG_BUILD = true;
    (:release)
    const IS_SIMULATOR_BUILD = false;

    const CUSTOMIZE_MENU_TITLE = Application.loadResource(Rez.Strings.SettingsMenuTitle) as String;

    const SUN_COLOR_LABEL = Application.loadResource(Rez.Strings.SunColorTitle) as String;
    const SUN_COLOR_NAMES = Application.loadResource(Rez.JsonData.SunColorNames) as Array<String>;
    const SUN_COLOR_PROPERTY_ID = "SunColor";
    const SUN_COLOR_PROPERTY_DEFAULT = 0;

    const GREETING_TIMES_LABEL = Application.loadResource(Rez.Strings.GreetingTimesTitle);
    const GREETING_TIMES_NAMES = Application.loadResource(Rez.JsonData.GreetingTimesNames) as Array<String>;
    const GREETING_TIMES_PROPERTY_ID = "GreetingTimes";
    const GREETING_TIMES_PROPERTY_DEFAULT = 0;

    const MORNING_START_HOUR_LABEL = Application.loadResource(Rez.Strings.MorningStartHourLabel);
    const MORNING_START_HOUR_PROPERTY_ID = "MorningStartHour";
    const MORNING_START_HOUR_DEFAULT = 6;

    const EVENING_START_HOUR_LABEL = Application.loadResource(Rez.Strings.EveningStartHourLabel);
    const EVENING_START_HOUR_PROPERTY_ID = "EveningStartHour";
    const EVENING_START_HOUR_PROPERTY_DEFAULT = 18;

    const NIGHT_START_HOUR_LABEL = Application.loadResource(Rez.Strings.NightStartHourLabel);
    const NIGHT_START_HOUR_PROPERTY_ID = "NightStartHour";
    const NIGHT_START_HOUR_PROPERTY_DEFAULT = 24;

}