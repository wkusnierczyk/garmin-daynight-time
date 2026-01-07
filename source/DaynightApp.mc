using Toybox.Application;
using Toybox.WatchUi;


class DaynightApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new DaynightView() ];
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    function getSettingsView() {
        return [ new DaynightMenu(), new DaynightDelegate() ];
    }

}