using Toybox.Application.Properties;
using Toybox.WatchUi;

import Toybox.Lang;

using Constants as CS;
using PropertyUtils as PU;


class DaynightDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {

        var id = item.getId();
        
        if (id.equals(CS.SUN_COLOR_PROPERTY_ID) && item instanceof WatchUi.MenuItem) {
            var currentValue = PropertyUtils.getPropertyElseDefault(CS.SUN_COLOR_PROPERTY_ID, CS.SUN_COLOR_PROPERTY_DEFAULT);
            var newValue = (currentValue + 1) % CS.SUN_COLOR_NAMES.size();
            Properties.setValue(CS.SUN_COLOR_PROPERTY_ID, newValue);
            item.setSubLabel(CS.SUN_COLOR_NAMES[newValue]);
        }

        if (id.equals(CS.GREETING_TIMES_PROPERTY_ID) && item instanceof WatchUi.MenuItem) {
            var currentValue = PropertyUtils.getPropertyElseDefault(CS.GREETING_TIMES_PROPERTY_ID, CS.GREETING_TIMES_PROPERTY_DEFAULT);
            var newValue = (currentValue + 1) % CS.GREETING_TIMES_NAMES.size();
            Properties.setValue(CS.GREETING_TIMES_PROPERTY_ID, newValue);
            item.setSubLabel(CS.GREETING_TIMES_NAMES[newValue]);
        }

        // TODO enforce constraints on non-overlapping times of day
        if (id.equals(CS.MORNING_START_HOUR_PROPERTY_ID) && item instanceof WatchUi.MenuItem) {
            var morningStartHour = item.getLabel().toNumber();
            Properties.setValue(CS.MORNING_START_HOUR_PROPERTY_ID, morningStartHour);
        }

        if (id.equals(CS.EVENING_START_HOUR_PROPERTY_ID) && item instanceof WatchUi.MenuItem) {
            var eveningStartHour = item.getLabel().toNumber();
            Properties.setValue(CS.EVENING_START_HOUR_PROPERTY_ID, eveningStartHour);
            var nightStartHour = PU.getPropertyElseDefault(CS.NIGHT_START_HOUR_PROPERTY_ID, CS.NIGHT_START_HOUR_PROPERTY_DEFAULT);
            if (eveningStartHour > nightStartHour) {
                Properties.setValue(CS.NIGHT_START_HOUR_PROPERTY_ID, eveningStartHour + 1);
            }

        }

        if (id.equals(CS.NIGHT_START_HOUR_LABEL) && item instanceof WatchUi.MenuItem) {
            var nightStartHour = item.getLabel().toNumber();
            Properties.setValue(CS.NIGHT_START_HOUR_PROPERTY_ID, nightStartHour);
            var eveningStartHour = PU.getPropertyElseDefault(CS.EVENING_START_HOUR_PROPERTY_ID, CS.EVENING_START_HOUR_PROPERTY_DEFAULT);
            if (nightStartHour < eveningStartHour) {
                Properties.setValue(CS.EVENING_START_HOUR_LABEL, nightStartHour - 1);
            }
        }

    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
