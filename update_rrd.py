#!/usr/bin/python
import sys
import time
import random
import rrdtool
import urllib2
import json
 
temperature = 0
pressure = 0
YOURDEVICEID = 
ACCESS_TOKEN= 


def read_metric(self, metric):
	response = urllib2.urlopen('https://api.spark.io/v1/devices/' + self.YOURDEVICEID + '/' + metric + '?access_token=' + self.ACCESS_TOKEN)
	html = response.read()
	reading = json.loads(html)
	result = reading['result']
	return result
	


def update_rrd(self, metric):
	while 1:
	 total_input_traffic += random.randrange(1000, 1500)
	 total_output_traffic += random.randrange(1000, 3000)
	 ret = rrdtool.update('speed.rrd','N:' + `total_input_traffic` + ':' + `total_output_traffic`);
	 if ret:
	 print rrdtool.error()
	 time.sleep(300)



# main class if this file is used directly
if __name__ == '__main__':
	print "Temperature (Both): " + str(round(read_metric['temp'],2)) + " °C"
#	print "Pressure (Both): " + str(round(both['pressure']/10,2)) + " hPa"
