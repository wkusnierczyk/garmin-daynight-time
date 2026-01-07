using Toybox.Application.Properties;
using Toybox.WatchUi;

import Toybox.Lang;

using Constants as CS;


class DaynightDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {

        var id = item.getId();
        
        if (id.equals(CS.SUN_COLOR_PROPERTY_ID) && item instanceof WatchUi.MenuItem) {
            var currentIndex = PropertyUtils.getPropertyElseDefault(CS.SUN_COLOR_PROPERTY_ID, CS.SUN_COLOR_PROPERTY_DEFAULT);
            var newIndex = (currentIndex + 1) % CS.SUN_COLOR_NAMES.size();
            Properties.setValue(CS.SUN_COLOR_PROPERTY_ID, newIndex);
            item.setSubLabel(CS.SUN_COLOR_NAMES[newIndex]);
        }

    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
