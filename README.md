# Garmin Daynight Time

A minimalist, elegant, nerdy Garmin Connect IQ watch face that displays the current time as a position of the sun along a day-night circle.

![Daynight Time](resources/graphics/DaynightTimeHero2-small.png)

Available from [Garmin Connect IQ Developer portal](https://apps.garmin.com/apps/b46eb668-f495-4db4-8f98-f28a4bd9cca5) or through the Connect IQ mobile app.

> **Note**  
> Daynight Time is part of a [collection of unconventional Garmin watch faces](https://github.com/wkusnierczyk/garmin-watch-faces). It has been developed for fun, as a proof of concept, and as a learning experience.
> It is shared _as is_ as an open source project, with no commitment to long term maintenance and further feature development.
>
> Please use [issues](https://github.com/wkusnierczyk/garmin-daynight-time/issues) to provide bug reports or feature requests.  
> Please use [discussions](https://github.com/wkusnierczyk/garmin-daynight-time/discussions) for any other comments.
>
> All feedback is wholeheartedly welcome.

## Contents

* [Daynight time](#daynight-time)
* [Features](#features)
* [Fonts](#fonts)
* [Build, test, deploy](#build-test-deploy)

## Daynight time

Daynight Time uses information about the sunrise and sunset at the current location on the current date to draw a circle with yellow indicating the duration of the day, and blue indicating the duration of the night.
It also draws a circle, symbolising the position of the sun in the sky (or under the horizon).
The sun is colored differently for night, morning, afternoon, and evening hours.

> **Note**  
> Full turn corresponds to 24 hours. Thus, the sun at the west indicates 6AM, not 3AM; east indicates 6PM, not 3PM; south indicates midnight, not 6PM; and so on.

In addition, Daynight Time displays a greeting, using the time of day to choose an appropriate greeting text.

For the purpose of Daynight Time, the names of time of day re defined a follows:

| Time of day | From    | To      |
| :---------- | :-----: | :-----: |
| Morning     | Sunrise | Noon    |
| Afternoon   | Noon    | Sunset  |
| Evening     | Sunset  | 8PM     |
| Night       | 8PM     | Sunrise |


## Features

The Daynight Time watch face supports the following features:

|Screenshot|Description|
|-|:-|
|![](resources/graphics/DaynightTime5.png)|**Day-Night outline**<br/> The duration of day and night are indicated by the yellow and blue colors. The current time of day is indicated by the sun circle.|
|![](resources/graphics/DaynightTime6.png)|**Sun colors**<br/> The sun circle is colored depending on the time of day.|
|![](resources/graphics/DaynightTime7.png)|**Greeting message**<br/> The greeting message reflects the time of day.|
|![](resources/graphics/DaynightTime8.png)|**Greeting colors**<br/> The greeting colors match those of the sun circle.|

> **Limitations**  
> * The twilight indicators (short orange parts of the outline between the day and night parts) are _not_ proportional to the actual duration of twilight. 
> The are not calculated based on actual dawn and dusk times, but rather have fixed length and are for decorative purposes only. 
> * The edge cases of polar night and polar day are not handled.
> The look of the watch face during such events is undefined.
>
> Future versions may fix both issues.

## Fonts

The Daynight Time watch face uses custom fonts:

* [EncodeSansCondensed](https://fonts.google.com/specimen/Encode+Sans+Condensed) SemiBold (`Good`, `Dear!`) and Bold (time of day).

> The development of Garmin watch faces motivated the implementation of two useful tools:
> * A TTF to FNT+PNG converter ([`ttf2bmp`](https://github.com/wkusnierczyk/ttf2bmp)).  
> Garmin watches use non-scalable fixed-size bitmap fonts, and cannot handle variable size True Type fonts directly.
> * An font scaler automation tool ([`garmin-font-scaler`](https://github.com/wkusnierczyk/garmin-font-scaler)).  
> Garmin watches come in a variety of shapes and resolutions, and bitmap fonts need to be scaled for each device proportionally to its resolution.

The font development proceeded as follows:

* The fonts were downloaded from [Google Fonts](https://fonts.google.com/) as True Type  (`.ttf`) fonts.
* The fonts were converted to bitmaps as `.fnt` and `.png` pairs using the open source command-line [`ttf2bmp`](https://github.com/wkusnierczyk/ttf2bmp) converter.
* The font sizes were established to match the Garmin Fenix 7X Solar watch 280x280 pixel screen resolution.
* The fonts were then scaled proportionally to match other screen sizes available on Garmin watches using the [`garmin-font-scaler`](https://github.com/wkusnierczyk/garmin-font-scaler) tool.


The table below lists all font sizes provided for the supported screen resolutions.

| Resolution |    Shape     | Element  |             Font             | Size |
| ---------: | :----------- | :------- | :--------------------------- | ---: |
|  148 x 205 | rectangle    | Daynight | EncodeSansCondensed bold     |   20 |
|  148 x 205 | rectangle    | Default  | EncodeSansCondensed semibold |   16 |
|  176 x 176 | semi-octagon | Daynight | EncodeSansCondensed bold     |   23 |
|  176 x 176 | semi-octagon | Default  | EncodeSansCondensed semibold |   19 |
|  215 x 180 | semi-round   | Daynight | EncodeSansCondensed bold     |   24 |
|  215 x 180 | semi-round   | Default  | EncodeSansCondensed semibold |   20 |
|  218 x 218 | round        | Daynight | EncodeSansCondensed bold     |   29 |
|  218 x 218 | round        | Default  | EncodeSansCondensed semibold |   24 |
|  240 x 240 | round        | Daynight | EncodeSansCondensed bold     |   32 |
|  240 x 240 | rectangle    | Daynight | EncodeSansCondensed bold     |   32 |
|  240 x 240 | round        | Default  | EncodeSansCondensed semibold |   26 |
|  240 x 240 | rectangle    | Default  | EncodeSansCondensed semibold |   26 |
|  260 x 260 | round        | Daynight | EncodeSansCondensed bold     |   34 |
|  260 x 260 | round        | Default  | EncodeSansCondensed semibold |   29 |
|  280 x 280 | round        | Daynight | EncodeSansCondensed bold     |   37 |
|  280 x 280 | round        | Default  | EncodeSansCondensed semibold |   31 |
|  320 x 360 | rectangle    | Daynight | EncodeSansCondensed bold     |   42 |
|  320 x 360 | rectangle    | Default  | EncodeSansCondensed semibold |   35 |
|  360 x 360 | round        | Daynight | EncodeSansCondensed bold     |   48 |
|  360 x 360 | round        | Default  | EncodeSansCondensed semibold |   40 |
|  390 x 390 | round        | Daynight | EncodeSansCondensed bold     |   52 |
|  390 x 390 | round        | Default  | EncodeSansCondensed semibold |   43 |
|  416 x 416 | round        | Daynight | EncodeSansCondensed bold     |   55 |
|  416 x 416 | round        | Default  | EncodeSansCondensed semibold |   46 |
|  454 x 454 | round        | Daynight | EncodeSansCondensed bold     |   60 |
|  454 x 454 | round        | Default  | EncodeSansCondensed semibold |   50 |

## Build, test, deploy

To modify and build the sources, you need to have installed:

* [Visual Studio Code](https://code.visualstudio.com/) with [Monkey C extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/).
* [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/).

Consult [Monkey C Visual Studio Code Extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/) for how to execute commands such as `build` and `test` to the Monkey C runtime.

You can use the included `Makefile` to conveniently trigger some of the actions from the command line.

```bash
# build binaries from sources
make build

# run unit tests -- note: requires the simulator to be running
make test

# run the simulation
make run

# clean up the project directory
make clean
```

To sideload your application to your Garmin watch, see [developer.garmin.com/connect-iq/connect-iq-basics/your-first-app](https://developer.garmin.com/connect-iq/connect-iq-basics/your-first-app/).
