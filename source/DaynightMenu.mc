using Toybox.Application.Properties;
using Toybox.WatchUi;

import Toybox.Lang;

using Constants as CS;


class DaynightMenu extends WatchUi.Menu2 {

    function initialize() {

        Menu2.initialize({:title => CS.CUSTOMIZE_MENU_TITLE});

        var sunColorIndex = PropertyUtils.getPropertyElseDefault(CS.SUN_COLOR_PROPERTY_ID, CS.SUN_COLOR_PROPERTY_DEFAULT);
        var sunColorName = CS.SUN_COLOR_NAMES[sunColorIndex];
        addItem(new WatchUi.MenuItem(
            CS.SUN_COLOR_LABEL, 
            sunColorName, 
            CS.SUN_COLOR_PROPERTY_ID, 
            null
        ));

        // var morningHour = PropertyUtils.getPropertyElseDefault(CS.MORNING_HOUR_PROPERTY_ID, CS.MORNING_HOUR_PROPERTY_DEFAULT);
        // addItem(new WatchUi.MenuItem(
        //     CS.MORNING_HOUR_LABEL,
        //     morningHour.toString(),
        //     CS.MORNING_HOUR_PROPERTY_ID,
        //     null
        // ));

        // var afternoonHour = PropertyUtils.getPropertyElseDefault(CS.AFTERNOON_HOUR_PROPERTY_ID, CS.AFTERNOON_HOUR_PROPERTY_DEFAULT);
        // addItem(new WatchUi.MenuItem(
        //     CS.AFTERNOON_HOUR_LABEL,
        //     afternoonHour.toString(),
        //     CS.AFTERNOON_HOUR_PROPERTY_ID,
        //     null
        // ));

        // var eveningHour = PropertyUtils.getPropertyElseDefault(CS.EVENING_HOUR_PROPERTY_ID, CS.EVENING_HOUR_PROPERTY_DEFAULT);
        // addItem(new WatchUi.MenuItem(
        //     CS.EVENING_HOUR_LABEL,
        //     eveningHour.toString(),
        //     CS.EVENING_HOUR_PROPERTY_ID,
        //     null
        // ));

        // var nightHour = PropertyUtils.getPropertyElseDefault(CS.NIGHT_HOUR_PROPERTY_ID, CS.NIGHT_HOUR_PROPERTY_DEFAULT);
        // addItem(new WatchUi.MenuItem(
        //     CS.NIGHT_HOUR_LABEL,
        //     nightHour.toString(),
        //     CS.NIGHT_HOUR_PROPERTY_ID,
        //     null
        // ));

    }

}
