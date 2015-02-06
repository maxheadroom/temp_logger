#!/bin/bash

############################
#
# Parameters to adjust
#
############################
RRDPATH="/home/fzurell/temp_logger"
IMGPATH="$RRDPATH/web"
RRDFILE="climate.rrd"
LAT="52.5243700N"
LON="13.4105300E"

# Graph Colors
RAWCOLOUR="#FF9933"
RAWCOLOUR2="#0000FF"
RAWCOLOUR3="#336699"
RAWCOLOUR4="#006600"
RAWCOLOUR5="#000000"
TRENDCOLOUR="#FFFF00"

# Calculating Civil Twilight based on location from LAT LON
DUSKHR=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun rises/{:a;n;/Nautical twilight/b;p;ba}' | cut -c 45-46`
DUSKMIN=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun rises/{:a;n;/Nautical twilight/b;p;ba}' | cut -c 47-48`
DAWNHR=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun rises/{:a;n;/Nautical twilight/b;p;ba}' | cut -c 30-31`
DAWNMIN=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun rises/{:a;n;/Nautical twilight/b;p;ba}' | cut -c 32-33`

# Calculating sunset/sunrise based on location from LAT LON
SUNRISEHR=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun transits/{:a;n;/Civil twilight/b;p;ba}' | cut -c 30-31`
SUNRISEMIN=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun transits/{:a;n;/Civil twilight/b;p;ba}' | cut -c 32-33`
SUNSETHR=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun transits/{:a;n;/Civil twilight/b;p;ba}' | cut -c 45-46`
SUNSETMIN=`/usr/bin/sunwait sun up $LAT $LON -p | sed -n '/Sun transits/{:a;n;/Civil twilight/b;p;ba}' | cut -c 47-48`

# Converting to seconds
SUNR=$(($SUNRISEHR * 3600 + $SUNRISEMIN * 60))
SUNS=$(($SUNSETHR * 3600 + $SUNSETMIN * 60))
DUSK=$(($DUSKHR * 3600 + $DUSKMIN * 60))
DAWN=$(($DAWNHR * 3600 + $DAWNMIN * 60))

############################
#
# Creating graphs
#
############################
# temperature hour
rrdtool graph $IMGPATH/temperature_hour.png --start -6h --end now \
-v "Last 6 hours (°C)" \
--full-size-mode \
--width=785 --height=400 \
--slope-mode \
--color=SHADEB#9999CC \
--watermark="© Falko Zurell - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
DEF:temp2=$RRDPATH/$RRDFILE:dht22temperature:AVERAGE \
CDEF:nightplus=LTIME,86400,%,$SUNR,LT,INF,LTIME,86400,%,$SUNS,GT,INF,UNKN,temp1,*,IF,IF \
CDEF:nightminus=LTIME,86400,%,$SUNR,LT,NEGINF,LTIME,86400,%,$SUNS,GT,NEGINF,UNKN,temp1,*,IF,IF \
AREA:nightplus#E0E0E0 \
AREA:nightminus#E0E0E0 \
CDEF:dusktilldawn=LTIME,86400,%,$DAWN,LT,INF,LTIME,86400,%,$DUSK,GT,INF,UNKN,temp1,*,IF,IF \
CDEF:dawntilldusk=LTIME,86400,%,$DAWN,LT,NEGINF,LTIME,86400,%,$DUSK,GT,NEGINF,UNKN,temp1,*,IF,IF \
AREA:dusktilldawn#CCCCCC \
AREA:dawntilldusk#CCCCCC \
COMMENT:"  Location         Last        Avg\l" \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
COMMENT:"\u" \
COMMENT:"Dawn\:    $DAWNHR\:$DAWNMIN\r" \
COMMENT:"\u" \
COMMENT:"Sunrise\: $SUNRISEHR\:$SUNRISEMIN\r" \
LINE1:temp1$RAWCOLOUR:"Temperature  " \
LINE1:temp2$RAWCOLOUR2:"DHT22 Temp.   " \
GPRINT:temp1:LAST:"%5.1lf °C" \
GPRINT:temp1:AVERAGE:"%5.1lf °C\l" \
COMMENT:"\u" \
COMMENT:"Sunset\:  $SUNSETHR\:$SUNSETMIN\r" \
COMMENT:"\u" \
COMMENT:"Dusk\:    $DUSKHR\:$DUSKMIN\r" \
HRULE:0#66CCFF:"freezing\l"

# Pressure for the hour
rrdtool graph $IMGPATH/pressure_hour.png --start -6h --end now \
-v "Last 6 hours (°C)" \
--full-size-mode \
--width=785 --height=400 \
--slope-mode \
--color=SHADEB#9999CC \
--watermark="© Falko Zurell - 2014" \
DEF:pressure=$RRDPATH/$RRDFILE:pressure:AVERAGE \
CDEF:nightplus=LTIME,86400,%,$SUNR,LT,INF,LTIME,86400,%,$SUNS,GT,INF,UNKN,pressure,*,IF,IF \
CDEF:nightminus=LTIME,86400,%,$SUNR,LT,NEGINF,LTIME,86400,%,$SUNS,GT,NEGINF,UNKN,pressure,*,IF,IF \
AREA:nightplus#E0E0E0 \
AREA:nightminus#E0E0E0 \
CDEF:dusktilldawn=LTIME,86400,%,$DAWN,LT,INF,LTIME,86400,%,$DUSK,GT,INF,UNKN,pressure,*,IF,IF \
CDEF:dawntilldusk=LTIME,86400,%,$DAWN,LT,NEGINF,LTIME,86400,%,$DUSK,GT,NEGINF,UNKN,pressure,*,IF,IF \
AREA:dusktilldawn#CCCCCC \
AREA:dawntilldusk#CCCCCC \
COMMENT:"  Location         Last        Avg\l" \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
COMMENT:"\u" \
COMMENT:"Dawn\:    $DAWNHR\:$DAWNMIN\r" \
COMMENT:"\u" \
COMMENT:"Sunrise\: $SUNRISEHR\:$SUNRISEMIN\r" \
LINE1:pressure$RAWCOLOUR:"Pressure  " \
GPRINT:pressure:LAST:"%5.1lf hPa" \
GPRINT:pressure:AVERAGE:"%5.1lf hPa\l" \
COMMENT:"\u" \
COMMENT:"Sunset\:  $SUNSETHR\:$SUNSETMIN\r" \
COMMENT:"\u" \
COMMENT:"Dusk\:    $DUSKHR\:$DUSKMIN\r" 

# Humidity for the hour
rrdtool graph $IMGPATH/humidity_hour.png --start -6h --end now \
-v "Last 6 hours (°C)" \
--full-size-mode \
--width=785 --height=400 \
--slope-mode \
--color=SHADEB#9999CC \
--watermark="© Falko Zurell - 2014" \
DEF:humidity=$RRDPATH/$RRDFILE:humidity:AVERAGE \
CDEF:nightplus=LTIME,86400,%,$SUNR,LT,INF,LTIME,86400,%,$SUNS,GT,INF,UNKN,humidity,*,IF,IF \
CDEF:nightminus=LTIME,86400,%,$SUNR,LT,NEGINF,LTIME,86400,%,$SUNS,GT,NEGINF,UNKN,humidity,*,IF,IF \
AREA:nightplus#E0E0E0 \
AREA:nightminus#E0E0E0 \
CDEF:dusktilldawn=LTIME,86400,%,$DAWN,LT,INF,LTIME,86400,%,$DUSK,GT,INF,UNKN,humidity,*,IF,IF \
CDEF:dawntilldusk=LTIME,86400,%,$DAWN,LT,NEGINF,LTIME,86400,%,$DUSK,GT,NEGINF,UNKN,humidity,*,IF,IF \
AREA:dusktilldawn#CCCCCC \
AREA:dawntilldusk#CCCCCC \
COMMENT:"  Location         Last        Avg\l" \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
COMMENT:"\u" \
COMMENT:"Dawn\:    $DAWNHR\:$DAWNMIN\r" \
COMMENT:"\u" \
COMMENT:"Sunrise\: $SUNRISEHR\:$SUNRISEMIN\r" \
LINE1:humidity$RAWCOLOUR:"Pressure  " \
GPRINT:humidity:LAST:"%5.1lf %" \
GPRINT:humidity:AVERAGE:"%5.1lf %\l" \
COMMENT:"\u" \
COMMENT:"Sunset\:  $SUNSETHR\:$SUNSETMIN\r" \
COMMENT:"\u" \
COMMENT:"Dusk\:    $DUSKHR\:$DUSKMIN\r" 