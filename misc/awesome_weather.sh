#!/bin/bash

############################
#
# Parameters to adjust
#
############################
RRDPATH="/home/fzurell/temp_logger"
IMGPATH="/tmp/temp_logger/"
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
#hour
rrdtool graph $IMGPATH/hour.png --start -6h --end now \
-v "Last 6 hours (°C)" \
--full-size-mode \
--width=785 --height=500 \
--slope-mode \
--color=SHADEB#9999CC \
--watermark="© Bart Bania - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
DEF:temp2=$RRDPATH/$RRDFILE:temperature:MAX \
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
LINE1:temp1$RAWCOLOUR:"Average  " \
LINE1:temp2$RAWCOLOUR2:"Max   " \
GPRINT:temp1:LAST:"%5.1lf °C" \
GPRINT:temp1:AVERAGE:"%5.1lf °C\l" \
COMMENT:"\u" \
COMMENT:"Sunset\:  $SUNSETHR\:$SUNSETMIN\r" \
COMMENT:"\u" \
COMMENT:"Dusk\:    $DUSKHR\:$DUSKMIN\r" \
HRULE:0#66CCFF:"freezing\l"

#day
rrdtool graph $IMGPATH/day.png --start -1d --end now \
-v "Last day (°C)" \
--full-size-mode \
--width=785 --height=500 \
--slope-mode \
--color=SHADEA#9999CC \
--watermark="© Bart Bania - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
DEF:temp2=$RRDPATH/$RRDFILE:temperature:MAX \
CDEF:trend1=temp1,21600,TREND \
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
LINE1:temp1$RAWCOLOUR:"Average   " \
LINE1:temp2$RAWCOLOUR2:"Max   " \
GPRINT:temp1:LAST:"%5.1lf °C" \
GPRINT:temp1:AVERAGE:"%5.1lf °C\l" \
COMMENT:"\u" \
COMMENT:"Sunset\:  $SUNSETHR\:$SUNSETMIN\r" \
COMMENT:"\u" \
COMMENT:"Dusk\:    $DUSKHR\:$DUSKMIN\r" \
HRULE:0#66CCFF:"freezing\l"

#week
rrdtool graph $IMGPATH/week.png --start -1w \
--full-size-mode \
-v "Last week (°C)" \
--width=785 --height=500 \
--slope-mode \
--color=SHADEB#9999CC \
--watermark="© Bart Bania - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
DEF:temp2=$RRDPATH/$RRDFILE:temperature:MAX \
CDEF:nightplus=LTIME,86400,%,$SUNR,LT,INF,LTIME,86400,%,$SUNS,GT,INF,UNKN,temp1,*,IF,IF \
CDEF:nightminus=LTIME,86400,%,$SUNR,LT,NEGINF,LTIME,86400,%,$SUNS,GT,NEGINF,UNKN,temp1,*,IF,IF \
AREA:nightplus#E0E0E0 \
AREA:nightminus#E0E0E0 \
CDEF:dusktilldawn=LTIME,86400,%,$DAWN,LT,INF,LTIME,86400,%,$DUSK,GT,INF,UNKN,temp1,*,IF,IF \
CDEF:dawntilldusk=LTIME,86400,%,$DAWN,LT,NEGINF,LTIME,86400,%,$DUSK,GT,NEGINF,UNKN,temp1,*,IF,IF \
AREA:dusktilldawn#CCCCCC \
AREA:dawntilldusk#CCCCCC \
COMMENT:"  Location         Last        Avg\l" \
COMMENT:"\u" \
COMMENT:"Location         Last        Avg  \r" \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
COMMENT:"\u" \
LINE1:temp1$RAWCOLOUR:"Average   " \
LINE1:temp2$RAWCOLOUR2:"Max   " \
GPRINT:temp1:LAST:"%5.1lf °C" \
GPRINT:temp1:AVERAGE:"%5.1lf °C\l" \
GPRINT:temp1:MIN:"%5.1lf °C\l" \
GPRINT:temp1:MAX:"%5.1lf °C\l" \
COMMENT:"\u" \
HRULE:0#66CCFF:"freezing\l"

#month
rrdtool graph $IMGPATH/month.png --start -1m \
-v "Last month (°C)" \
--full-size-mode \
--width=700 --height=400 \
--slope-mode \
--color=SHADEA#9999CC \
--watermark="© Bart Bania - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
COMMENT:"  Location         Last        Avg\l" \
COMMENT:"\u" \
COMMENT:"Location         Last        Avg  \r" \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
COMMENT:"\u" \
LINE1:temp1$RAWCOLOUR:"Water Pipe   " \
GPRINT:temp1:LAST:"%5.1lf °C" \
GPRINT:temp1:AVERAGE:"%5.1lf °C\l" \
COMMENT:"\u" \
HRULE:0#66CCFF:"freezing\l"

#year
rrdtool graph $IMGPATH/year.png --start -1y \
--full-size-mode \
-v "Last year (°C)" \
--width=700 --height=400 \
--color=SHADEB#9999CC \
--slope-mode \
--watermark="© Bart Bania - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
COMMENT:"  Location         Last        Avg\l" \
COMMENT:"\u" \
COMMENT:"Location         Last        Avg  \r" \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
COMMENT:"\u" \
LINE1:temp1$RAWCOLOUR:"Water Pipe   " \
GPRINT:temp1:LAST:"%5.1lf °C" \
GPRINT:temp1:AVERAGE:"%5.1lf °C\l" \
COMMENT:"\u" \
HRULE:0#66CCFF:"freezing\l"

#averages
rrdtool graph $IMGPATH/avg.png --start -1w \
-v "Weekly averages (°C)" \
--full-size-mode \
--width=700 --height=400 \
--slope-mode \
--color=SHADEB#9999CC \
--watermark="© Bart Bania - 2014" \
DEF:temp1=$RRDPATH/$RRDFILE:temperature:AVERAGE \
CDEF:trend1=temp1,86400,TREND \
CDEF:nightplus=LTIME,86400,%,$SUNR,LT,INF,LTIME,86400,%,$SUNS,GT,INF,UNKN,temp1,*,IF,IF \
CDEF:nightminus=LTIME,86400,%,$SUNR,LT,NEGINF,LTIME,86400,%,$SUNS,GT,NEGINF,UNKN,temp1,*,IF,IF \
AREA:nightplus#CCCCCC \
AREA:nightminus#CCCCCC \
COMMENT:"\t\t\t\t\t\t---------------------------\l" \
LINE2:trend1$RAWCOLOUR4:"Main Room 6h average\l" \
COMMENT:"\u" \
COMMENT:"\u" \
