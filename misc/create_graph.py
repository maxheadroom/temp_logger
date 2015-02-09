import sys
import rrdtool


# Graph Colors
COLOUR1="#294CFF"
COLOUR2="#1F7A34"
COLOUR3="#FFF800"
COLOUR4="#CC1414"
COLOUR5="#000000"
TRENDCOLOUR="#FFFF00"

TOOL_HOME="/home/fzurell/temp_logger"
WEB_HOME=TOOL_HOME + "/web"
RRDFILE=TOOL_HOME + "/climate.rrd"



def generate_temperature(rrdfile):

	for sched in ['hourly', 'daily' , 'weekly', 'monthly']:

		if sched == 'weekly':
			period = 'w'
		elif sched == 'hourly':
			period = 'h'
		elif sched == 'daily':
			period = 'd'
		elif sched == 'monthly':
			period = 'm'

		rrdtool.graph(WEB_HOME+"/temperature_%s.png" %(sched),
		"-w" , "800",
		"-h", "400",
		"--imgformat", "PNG",
		"--slope-mode",
		"--start" , "-1%s" %(period),
		"--end", "now",
		"--font", "DEFAULT:7:",
		"--right-axis", "0:0",
		"--right-axis-label", "rel. Humidity in %",
		"--vertical-label", "temperature ( C)",
		"DEF:temp=" + rrdfile +":temperature:AVERAGE",
		"DEF:tmin=" + rrdfile +":temperature:MIN",
		"DEF:tmax=" + rrdfile +":temperature:MAX", 
		"DEF:dht=" + rrdfile +":dht22temperature:AVERAGE",
		"DEF:dewpoint=" + rrdfile +":dewpoint:AVERAGE",
		"DEF:humidity=" + rrdfile +":humidity:AVERAGE", 
		"LINE1:temp" + COLOUR1 + ":temp \l",
		"LINE1:dht" + COLOUR2 +":temp dht22\l",
		"LINE1:dewpoint" + COLOUR3 +":Dew Point\l",
		"LINE1:humidity"+ COLOUR4 + ":Humidity in %\r",
		"GPRINT:temp:LAST:                 Cur\:%5.1lf C",
		"GPRINT:temp:AVERAGE:Avg\:%5.1lf C",
		"GPRINT:tmin:MIN:Min\:%5.1lf C",
		"GPRINT:tmax:MAX:Max\:%5.1lf C\n")

def generate_pressure(rrdfile):
	for sched in ['hourly', 'daily' , 'weekly', 'monthly']:
		if sched == 'weekly':
			period = 'w'
		elif sched == 'hourly':
			period = 'h'
		elif sched == 'daily':
			period = 'd'
		elif sched == 'monthly':
			period = 'm'

		rrdtool.graph(WEB_HOME+"/pressure_%s.png" %(sched),
		"-w" , "800",
		"-h" , "400",
		"--imgformat", "PNG",
		"--slope-mode",
		"--start" , "-1%s" %(period),
		"--end", "now",
		"--font", "DEFAULT:7:",
		"--vertical-label", "pressure ( hPa)",
		"DEF:pressure=" + rrdfile +":pressure:AVERAGE",
		"DEF:pmin=" + rrdfile +":pressure:MIN",
		"DEF:pmax=" + rrdfile +":pressure:MAX", 
		"LINE1:pressure" + COLOUR5 + ":Pressure \l",
		"GPRINT:pressure:LAST:                 Cur\:%5.1lf hPa",
		"GPRINT:pressure:AVERAGE:Avg\:%5.1lf hPa",
		"GPRINT:pmin:MIN:Min\:%5.1lf hPa",
		"GPRINT:pmax:MAX:Max\:%5.1lf hPa\n")



# main class if this file is used directly
if __name__ == '__main__':
	generate_temperature(RRDFILE)
	generate_pressure(RRDFILE)
