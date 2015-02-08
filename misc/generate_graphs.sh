#!/bin/bash


TOOL_HOME=/home/fzurell/temp_logger
WEB_HOME=/tmp/temp_logger/
RRDFILE=$TOOL_HOME/climate.rrd

# Graph Colors
COLOUR1="#294CFF"
COLOUR2="#1F7A34"
COLOUR3="#FFF800"
COLOUR4="#CC1414"
COLOUR5="#000000"
TRENDCOLOUR="#FFFF00"

cd $TOOL_HOME


/usr/bin/rrdtool graph temp_graph.png \
        -w 785 -h 120 -a PNG \
        --slope-mode \
        --start -4hours --end now \
		--watermark "`date`" \
        --font DEFAULT:7: \
        --vertical-label "temperature (°C)" \
        DEF:temp=$RRDFILE:temperature:AVERAGE \
		DEF:tmin=$RRDFILE:temperature:MIN \
		DEF:tmax=$RRDFILE:temperature:MAX \
		DEF:dht=$RRDFILE:dht22temperature:AVERAGE \
		DEF:dewpoint=$RRDFILE:dewpoint:AVERAGE \
		DEF:humidity=$RRDFILE:humidity:AVERAGE \
        LINE1:temp$COLOUR1:"temp \l" \
        LINE1:dht$COLOUR2:"temp dht22\l" \
        LINE1:dewpoint$COLOUR3:"Dew Point\l" \
		LINE1:humidity$COLOUR4:"Humidity in %\l" \
        GPRINT:temp:LAST:"                 Cur\:%5.1lf°C" \
        GPRINT:temp:AVERAGE:"Avg\:%5.1lf°C" \
        GPRINT:tmin:MIN:"Min\:%5.1lf°C" \
        GPRINT:tmax:MAX:"Max\:%5.1lf°C\n"




/usr/bin/rrdtool graph pressure_graph.png \
            -w 785 -h 120 -a PNG \
            --slope-mode \
            --start -4hours --end now \
            --watermark "`date`" \
            --font DEFAULT:7: \
            --vertical-label "Pressure (hPa)" \
            DEF:pressure=$RRDFILE:pressure:MAX \
            LINE1:pressure$COLOUR5:"pressure " \
            GPRINT:pressure:LAST:"                 Cur\:%5.1lfhPa" \
            GPRINT:pressure:AVERAGE:"Avg\:%5.1lfhPa" \
            GPRINT:pressure:MIN:"Min\:%5.1lfhPa" \
            GPRINT:pressure:MAX:"Max\:%5.1lfhPa\n"


cp *.png $WEB_HOME
