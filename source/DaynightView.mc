using Toybox.Application.Properties;
using Toybox.Graphics;
using Toybox.WatchUi;

import Toybox.Lang;

using Constants as CS;


class DaynightView extends WatchUi.WatchFace {

    private const _daynight as Daynight = new Daynight();

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc) {

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        var time = Time.now();

        if (CS.IS_SIMULATOR_BUILD) {
            var hour = 7;
            time = Time.today().add(new Time.Duration(hour * 3600));
        }        

       _daynight
            .forTime(time)
            .draw(dc);

    }

}