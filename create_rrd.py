import sys
import rrdtool
 
ret = rrdtool.create("climate.rrd", "--step", "60", "--start", '0',
 "DS:temperature:GAUGE:120:U:U",
 "DS:dht22temperature:GAUGE:120:U:U",
 "DS:pressure:GAUGE:120:U:U",
 "DS:humidity:GAUGE:120:U:U",
 "RRA:AVERAGE:0.5:1:600",
 "RRA:AVERAGE:0.5:6:700",
 "RRA:AVERAGE:0.5:24:775",
 "RRA:AVERAGE:0.5:288:797",
 "RRA:MAX:0.5:1:600",
 "RRA:MAX:0.5:6:700",
 "RRA:MAX:0.5:24:775",
 "RRA:MAX:0.5:444:797",
 "RRA:MIN:0.5:1:600",
 "RRA:MIN:0.5:6:700",
 "RRA:MIN:0.5:24:775",
 "RRA:MIN:0.5:444:797")
 
if ret:
 print rrdtool.error()
