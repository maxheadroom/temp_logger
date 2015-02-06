#!/bin/bash


TOOL_HOME=/home/fzurell/temp_logger
WEB_HOME=/tmp/temp_logger/

cd $TOOL_HOME


/usr/bin/rrdtool graph temp_graph.png \
        -w 785 -h 120 -a PNG \
        --slope-mode \
        --start -4hours --end now \
		--watermark "`date`" \
        --font DEFAULT:7: \
        --vertical-label "temperature (°C)" \
        DEF:temp=climate.rrd:temperature:AVERAGE \
        DEF:tmax=climate.rrd:temperature:MAX \
        DEF:tmin=climate.rrd:temperature:MIN \
        LINE1:temp#ff9900:"temp avg\l" \
        LINE1:tmax#FF0000:"temp max\l" \
        LINE1:tmin#0000FF:"temp min\l" \
        GPRINT:temp:LAST:"                 Cur\:%5.1lf°C" \
        GPRINT:temp:AVERAGE:"Avg\:%5.1lf°C" \
        GPRINT:tmin:MIN:"Min\:%5.1lf°C" \
        GPRINT:tmax:MAX:"Max\:%5.1lf°C\n"




/usr/bin/rrdtool graph pressure_graph.png \
            -w 785 -h 120 -a PNG \
            --slope-mode \
            --start -1days --end now \
            --watermark "`date`" \
            --font DEFAULT:7: \
            --vertical-label "Pressure (hPa)" \
            DEF:pressure=climate.rrd:pressure:MAX \
            LINE1:pressure#0000ff:"pressure " \
            GPRINT:pressure:LAST:"                 Cur\:%5.1lfhPa" \
            GPRINT:pressure:AVERAGE:"Avg\:%5.1lfhPa" \
            GPRINT:pressure:MIN:"Min\:%5.1lfhPa" \
            GPRINT:pressure:MAX:"Max\:%5.1lfhPa\n"


cp *.png $WEB_HOME
