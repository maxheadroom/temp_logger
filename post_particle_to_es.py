#!/usr/bin/env python
import ConfigParser
import json
import urllib2
from time import gmtime, strftime

import elasticsearch
from elasticsearch import Elasticsearch

temperature = 0
pressure = 0
YOURDEVICEID = ""
ACCESS_TOKEN = ""

DEBUG=True

es = Elasticsearch(["localhost:9200"])
es_default_index="particle"



def post_document_to_es(entry):
    global es, DEBUG, es_default_index

    if DEBUG:
        print("Using ES Index: " + es_default_index)
    try:
        res = es.index(index=es_default_index, doc_type="weather", timeout="120s" , body=entry)
    except elasticsearch.exceptions.RequestError as exp:
        print("ES error: " + exp.error)
        print("ES info: " + json.dumps(exp.info))
        print("Problem with: " + json.dumps(entry))
        # sys.exit(1)

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

	weather = {}
	weather["temperature"] = read_metric("temperature")
	weather["pressure"] = read_metric("pressure")
	weather["dht22temp"] = read_metric("dht22temp")
	weather["humidity"] = read_metric("humidity")
	weather["dewpoint"] = read_metric("dewpoint")
	weather["light"] = read_metric("light")
	weather["timestamp"] = strftime("%Y/%m/%d %H:%M:%S", gmtime())

	if DEBUG:
		print "Temperature: " + str(round(weather["temperature"],2)) + " C"
		print "Temperature DHT22: " + str(round(weather["dht22temp"],2)) + " C"
		print "Pressure: " + str(round(weather["pressure"],2)) + " kPa"
		print "Humidity: " + str(round(weather["humidity"],2)) + " %"
		print "Dew point: " + str(round(weather["dewpoint"],2)) + " C"
		print "Light: " + str(weather["light"])
		print "Timestamp: " + weather["timestamp"]
		print "JSON: \n\t" + json.dumps(weather)
	post_document_to_es(weather)
