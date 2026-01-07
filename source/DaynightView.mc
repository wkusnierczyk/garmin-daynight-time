using Toybox.Application.Properties;
using Toybox.Graphics;
using Toybox.WatchUi;


import Toybox.Lang;


class DaynightView extends WatchUi.WatchFace {

    private const _daynight as Daynight = new Daynight();

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() {
    }

    function onUpdate(dc) {

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        var time = System.getClockTime();
       _daynight
            .forTime(time)
            .draw(dc);

    }

}