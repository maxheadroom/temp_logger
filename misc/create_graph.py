import sys
import rrdtool
import ephem
from datetime import *
from dateutil import tz

# Graph Colors
COLOUR1="#294CFF"
COLOUR2="#1F7A34"
COLOUR3="#FFF800"
COLOUR4="#CC1414"
COLOUR5="#000000"
TRENDCOLOUR="#FFFF00"

LAT=52.5243700
LON=13.4105300

#TOOL_HOME="/home/fzurell/temp_logger"
TOOL_HOME="/Volumes/Repositories/temp_logger"
WEB_HOME=TOOL_HOME + "/web"
RRDFILE=TOOL_HOME + "/climate.rrd"

def compute_observer(lat, lon):
	
	# create a new observer object to calculate sunrise etc.
	observer = ephem.Observer()
	#PyEphem takes and returns only UTC times. 15:00 is noon in Fredericton
	observer.date = datetime.now()
	#Location of Fredericton, Canada
	observer.lon  = str(lon) #Note that lon should be in string format
	observer.lat  = str(lat)      #Note that lat should be in string format

	#Elevation of Fredericton, Canada, in metres
	observer.elev = 0

	#To get U.S. Naval Astronomical Almanac values, use these settings
	observer.pressure= 0
	observer.horizon = "-0:34"
	
	sunrise=observer.previous_rising(ephem.Sun()) #Sunrise
	noon   =observer.next_transit   (ephem.Sun(), start=sunrise) #Solar noon
	sunset =observer.next_setting   (ephem.Sun()) #Sunset

	# change horizon to calculate twilight and dusk
	observer.horizon = '-6' #-6=civil twilight, -12=nautical, -18=astronomical

	beg_twilight=observer.previous_rising(ephem.Sun(), use_center=True) #Begin civil twilight
	end_twilight=observer.next_setting   (ephem.Sun(), use_center=True) #End civil twilight
	
	SRHOUR = int(ephem.localtime(sunrise).strftime("%H")) * 3600
	SRMIN = int(ephem.localtime(sunrise).strftime("%M")) * 60
	
	SSHOUR = int(ephem.localtime(sunset).strftime("%H")) * 3600
	SSMIN = int(ephem.localtime(sunset).strftime("%M")) * 60
	
	DUSKHOUR = int(ephem.localtime(end_twilight).strftime("%H")) * 3600
	DUSKMIN = int(ephem.localtime(end_twilight).strftime("%M")) * 60

	DAWNHOUR = int(ephem.localtime(beg_twilight).strftime("%H")) * 3600
	DAWNMIN = int(ephem.localtime(beg_twilight).strftime("%M")) * 60
	
	SUNRISE = str(SRHOUR + SRMIN)
	SUNSET = str(SSHOUR + SSMIN)
	DUSK = str(DUSKHOUR + DUSKMIN)
	DAWN = str(DAWNHOUR + DAWNMIN)
	
	return [SUNRISE, SUNSET, DUSK, DAWN ]
	

def generate_temperature(rrdfile, observer):
	
	
	sunrise = observer[0]
	sunset = observer[1]
	dusk = observer[2]
	dawn = observer[3]
	

	for sched in ['hourly','halfday' , 'daily' , 'weekly', 'monthly']:

		if sched == 'weekly':
			period = '-1week'
		elif sched == 'hourly':
			period = '-1hour'
		elif sched == 'daily':
			period = '-1day'
		elif sched == 'halfday':
			period = '-6hours'
		elif sched == 'monthly':
			period = '-1month'

		rrdtool.graph(WEB_HOME+"/temperature_%s.png" %(sched),
		"-w" , "800",
		"-h", "400",
		"--title", "Last %s" %(sched),
		"--imgformat", "PNG",
		"--slope-mode",
		"--start" , period,
		"--end", "now",
		"--font", "DEFAULT:7:",
		"--right-axis", "1:0",
		"--right-axis-label", "rel. Humidity in %",
		"--vertical-label", "temperature ( C)",
		"DEF:temp=" + rrdfile +":temperature:AVERAGE",
		"DEF:tmin=" + rrdfile +":temperature:MIN",
		"DEF:tmax=" + rrdfile +":temperature:MAX", 
		"DEF:dht=" + rrdfile +":dht22temperature:AVERAGE",
		"DEF:dewpoint=" + rrdfile +":dewpoint:AVERAGE",
		"DEF:humidity=" + rrdfile +":humidity:AVERAGE", 
		"CDEF:nightplus=LTIME,86400,%,"+ sunrise + ",LT,INF,LTIME,86400,%," + sunset + ",GT,INF,UNKN,temp,*,IF,IF",
		"CDEF:nightminus=LTIME,86400,%," + sunrise + ",LT,NEGINF,LTIME,86400,%," + sunset +",GT,NEGINF,UNKN,temp,*,IF,IF",
		"AREA:nightplus#E0E0E0", 
		"AREA:nightminus#E0E0E0",
		"CDEF:dusktilldawn=LTIME,86400,%," + dawn + ",LT,INF,LTIME,86400,%," + dusk + ",GT,INF,UNKN,temp,*,IF,IF",
		"CDEF:dawntilldusk=LTIME,86400,%," + dawn +",LT,NEGINF,LTIME,86400,%," + dusk + ",GT,NEGINF,UNKN,temp,*,IF,IF",
		"AREA:dusktilldawn#CCCCCC",
		"AREA:dawntilldusk#CCCCCC",
		"LINE1:temp" + COLOUR1 + ":temp \l",
		"LINE1:dht" + COLOUR2 +":temp dht22\l",
		"LINE1:dewpoint" + COLOUR3 +":Dew Point\l",
		"LINE1:humidity"+ COLOUR4 + ":Humidity in %\l",
		"GPRINT:temp:LAST:Cur\:%5.1lf C",
		"GPRINT:temp:AVERAGE:Avg\:%5.1lf C",
		"GPRINT:tmin:MIN:Min\:%5.1lf C",
		"GPRINT:tmax:MAX:Max\:%5.1lf C")

def generate_pressure(rrdfile, observer):
	
	sunrise = observer[0]
	sunset = observer[1]
	dusk = observer[2]
	dawn = observer[3]
	
	
	for sched in ['hourly','halfday' , 'daily' , 'weekly', 'monthly']:

		if sched == 'weekly':
			period = '-1week'
		elif sched == 'hourly':
			period = '-1hours'
		elif sched == 'daily':
			period = '-1day'
		elif sched == 'halfday':
			period = '-6hours'
		elif sched == 'monthly':
			period = '-1month'

		rrdtool.graph(WEB_HOME+"/pressure_%s.png" %(sched),
		"-w" , "800",
		"-h" , "400",
		"--title", "Last %s" %(sched),
		"--imgformat", "PNG",
		"--slope-mode",
		"--start" , period,
		"--end", "now",
		"--font", "DEFAULT:7:",
		"--vertical-label", "pressure ( hPa)",
		"DEF:pressure=" + rrdfile +":pressure:AVERAGE",
		"DEF:pmin=" + rrdfile +":pressure:MIN",
		"DEF:pmax=" + rrdfile +":pressure:MAX", 
		"CDEF:nightplus=LTIME,86400,%,"+ sunrise + ",LT,INF,LTIME,86400,%," + sunset + ",GT,INF,UNKN,pressure,*,IF,IF",
		"CDEF:nightminus=LTIME,86400,%," + sunrise + ",LT,NEGINF,LTIME,86400,%," + sunset +",GT,NEGINF,UNKN,pressure,*,IF,IF",
		"AREA:nightplus#E0E0E0", 
		"AREA:nightminus#E0E0E0",
		"CDEF:dusktilldawn=LTIME,86400,%," + dawn + ",LT,INF,LTIME,86400,%," + dusk + ",GT,INF,UNKN,pressure,*,IF,IF",
		"CDEF:dawntilldusk=LTIME,86400,%," + dawn +",LT,NEGINF,LTIME,86400,%," + dusk + ",GT,NEGINF,UNKN,pressure,*,IF,IF",
		"AREA:dusktilldawn#CCCCCC",
		"AREA:dawntilldusk#CCCCCC",
		"LINE1:pressure" + COLOUR5 + ":Pressure \l",
		"GPRINT:pressure:LAST:Cur\:%5.1lf hPa",
		"GPRINT:pressure:AVERAGE:Avg\:%5.1lf hPa",
		"GPRINT:pmin:MIN:Min\:%5.1lf hPa",
		"GPRINT:pmax:MAX:Max\:%5.1lf hPa")



# main class if this file is used directly
if __name__ == '__main__':
	
	
	observer = compute_observer(LAT,LON)
	generate_temperature(RRDFILE, observer)
	generate_pressure(RRDFILE, observer)
