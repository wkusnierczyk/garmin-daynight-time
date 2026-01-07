using Toybox.Application;

import Toybox.Lang;


module Constants {

    const CUSTOMIZE_MENU_TITLE = Application.loadResource(Rez.Strings.SettingsMenuTitle) as String;

    const SUN_COLOR_MENU_TITLE = Application.loadResource(Rez.Strings.SunColorTitle) as String;
    const SUN_COLOR_NAMES = Application.loadResource(Rez.JsonData.SunColorNames) as Array<String>;
    const SUN_COLOR_PROPERTY_ID = "SunColor";
    const SUN_COLOR_PROPERTY_DEFAULT = 0;

}