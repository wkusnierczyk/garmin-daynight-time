using Toybox.Application;
using Toybox.Weather;
using Toybox.Position;
using Toybox.System;
using Toybox.Time;

import Toybox.Lang;


// --- Constants ---
const ERROR_MESSAGE_NO_DATA = "No Data";
const HOURS_IN_DAY = 24;

class SunDataProvider {

    // --- Private Variables ---
    private var _sunrise_moment;
    private var _sunset_moment;
    private var _current_location;
    private var _default_latitude;
    private var _default_longitude;

    // --- Initialization ---
    public function initialize() {

        // Zurich defaults
        _default_latitude = 47.3769;
        _default_longitude = 8.5417;
        
        _sunrise_moment = null;
        _sunset_moment = null;
        _current_location = null;
    }

    // --- Fluent API Methods ---

    /**
     * Updates the current location snapshot.
     * Returns self for fluent chaining.
     */
    public function updateLocation() as SunDataProvider {

        // Imnitialize with defaults
        _current_location = new Position.Location({
            :latitude => _default_latitude,
            :longitude => _default_longitude,
            :format => :degrees
        });

        var position_info = Position.getInfo();
        if (position_info has :position && position_info.position != null) {
            _current_location = position_info.position;
        }
        
        return self;
    }

    /**
     * Refreshes the sunrise/sunset data based on the stored location.
     * Returns self for fluent chaining.
     */
    public function refreshSunData() as SunDataProvider {
        if (_current_location == null) {
            return self;
        }

        var today = Time.today(); // Midnight today

        // Toybox.Weather.getSunrise/getSunset requires API Level 3.2.0
        if (Weather has :getSunrise) {
            _sunrise_moment = Weather.getSunrise(_current_location, today);
            _sunset_moment = Weather.getSunset(_current_location, today);
        }
        
        return self;
    }

    // --- Accessors (Non-fluent, return values) ---

    /**
     * Returns the sunrise Moment, or null if unavailable.
     */
    public function getSunrise() as Time.Moment or Null {
        return _sunrise_moment;
    }

    /**
     * Returns the sunset Moment, or null if unavailable.
     */
    public function getSunset() as Time.Moment or Null {
        return _sunset_moment;
    }
}