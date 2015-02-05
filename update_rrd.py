#!/usr/bin/python
import sys
import time
import random
import rrdtool
import urllib2
import json
import ConfigParser, os





 
temperature = 0
pressure = 0
YOURDEVICEID = ""
ACCESS_TOKEN = ""


def read_metric(metric):
	reading = None

	try:
		http_response = urllib2.urlopen('https://api.spark.io/v1/devices/' + YOURDEVICEID + '/' + metric + '?access_token=' + ACCESS_TOKEN)
		html_output = http_response.read()
		json_raw = json.loads(html_output)
		reading = json_raw['result']
	except urllib2.URLError, e:
		reading = None
		print "Unable to retrieve reading: ", e
	return reading


def update_rrd(temperature, pressure):
	 ret = rrdtool.update('climate.rrd','N:' + temperature + ':' + pressure);
	 if ret:
	    print rrdtool.error()
	 # time.sleep(300)



# main class if this file is used directly
if __name__ == '__main__':
	
	# read config information from file
	config = ConfigParser.ConfigParser()
	config.readfp(open('spark.cfg'))
	YOURDEVICEID = config.get('SparkCloud', 'deviceID')
	ACCESS_TOKEN = config.get('SparkCloud', 'accessToken')
	# print out config information
	print "Config DeviceID: " + YOURDEVICEID
	print "Config Access Token: " + ACCESS_TOKEN

	temp = read_metric("temp")
	pressure = read_metric("pressure")
	print "Temperature: " + str(round(temp,2)) + " C"
	print "Pressure: " + str(round(pressure,2)) + " hPa"
	update_rrd(temp, pressure)