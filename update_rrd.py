#!/usr/bin/python
import sys
import time
import random
import rrdtool
import urllib2
import json
 
total_input_traffic = 0
total_output_traffic = 0
 
while 1:
 total_input_traffic += random.randrange(1000, 1500)
 total_output_traffic += random.randrange(1000, 3000)
 ret = rrdtool.update('speed.rrd','N:' + `total_input_traffic` + ':' + `total_output_traffic`);
 if ret:
 print rrdtool.error()
 time.sleep(300)


var = 1
while var == 1:
   response = urllib2.urlopen('https://api.spark.io/v1/devices/YOURDEVICEID/read?access_token=YOURACCESSTOKEN')
   html = response.read()
   reading = json.loads(html)
   temperature = reading['result']
   with open("core-temp-log.txt", "a") as myfile:
      myfile.write(temperature)
      myfile.write('\n')
   myfile.close();
   time.sleep(60)
