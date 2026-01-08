using Toybox.Application;

import Toybox.Lang;


module Constants {

    const CUSTOMIZE_MENU_TITLE = Application.loadResource(Rez.Strings.SettingsMenuTitle) as String;

    const SUN_COLOR_LABEL = Application.loadResource(Rez.Strings.SunColorTitle) as String;
    const SUN_COLOR_NAMES = Application.loadResource(Rez.JsonData.SunColorNames) as Array<String>;
    const SUN_COLOR_PROPERTY_ID = "SunColor";
    const SUN_COLOR_PROPERTY_DEFAULT = 0;

    // const MORNING_HOUR_LABEL = Application.loadResource(Rez.Strings.MorningHourLabel);
    // const MORNING_HOUR_PROPERTY_ID = "MorningHour";
    // const MORNING_HOUR_PROPERTY_DEFAULT = 6;

    // const AFTERNOON_HOUR_LABEL = Application.loadResource(Rez.Strings.AfternoonHourLabel);
    // const AFTERNOON_HOUR_PROPERTY_ID = "AfternoonHour";
    // const AFTERNOON_HOUR_PROPERTY_DEFAULT = 12;

    // const EVENING_HOUR_LABEL = Application.loadResource(Rez.Strings.EveningHourLabel);
    // const EVENING_HOUR_PROPERTY_ID = "EveningHour";
    // const EVENING_HOUR_PROPERTY_DEFAULT = 18;

    // const NIGHT_HOUR_LABEL = Application.loadResource(Rez.Strings.NightHourLabel);
    // const NIGHT_HOUR_PROPERTY_ID = "NightHour";
    // const NIGHT_HOUR_PROPERTY_DEFAULT = 24;


}