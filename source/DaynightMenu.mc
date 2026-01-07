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
            CS.SUN_COLOR_MENU_TITLE, 
            sunColorName, 
            CS.SUN_COLOR_PROPERTY_ID, 
            null
        ));

    }

}
