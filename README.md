# Spark Core based Weather Station

This little assembly uses a Spark.io Core and two digital sensor to measure weather data.
The first sensor is the [MPL115A2 from Adafruit](https://www.adafruit.com/products/992). A barometric temperature and pressure sensor which communicates via the I2C protocol.
The other sensor is the [DHT22 from Adarfuit](https://www.adafruit.com/products/385), a digital temperature and humidity sensor.

The [Spark Core](http://spark.io/) itself is a tiny Arduino compatible computer that has built-in WiFi and Cloud connectivity. You can easily read and write it's pins from remote via the Spark Cloud.

# wiring 
I use a standard breadboard to connect all the components
![Spark.Core.MPL115A2 Bb](images/Spark.Core.MPL115A2_bb.png)
![Spark.Core.MPL115A2 Schem](images/Spark.Core.MPL115A2_schem.png)
![Spark.Core.Setup](images/Spark.Core.Setup.jpg)

## Material

 * [MPL115A2 from Adafruit](https://www.adafruit.com/products/992)
 * [DHT22 from Adarfuit](https://www.adafruit.com/products/385)
 * [Spark.io Core from Tinkersoup Berlin](https://www.tinkersoup.de/a-1545/)
 * Standard Breadboard
 * a few jumper cables

## Folders
### images
Contains the images the are used to generate this website. Things like the [Fritzing](http://fritzing.org/home/) Schemas etc.
### firmware_binary
A compiled version of the Spark Code code from the spark-code folder. This includes the external libraries.

You can either download this from the Spark.io Workbench in the web or compile it with the Spark.io Command Line tools.
### spark-core
The source code of Spark Core file. This contains some external libraries for the two sensors. They are from Adafruits Github account:

 * [MPL115A2 Driver](https://github.com/adafruit/Adafruit_MPL115A2)
 * [DHT22 Driver](https://github.com/adafruit/DHT-sensor-library)



### misc
Some miscellaneous files like shell scripts to generate graphs.
### web
contains the web files for the RRD graphs of the temperature readings

## Compiling Firmware
The easiest way to get the code to your core is to use the [command line interface](http://docs.spark.io/cli/) from Spark.io.
Once you've installed that and logged in to the Spark Cloud you can compile the code in the cloud:

```shell
cd temp_logger
temp_logger fzurell$ spark compile spark-code
Including:
    /Volumes/Repositories/temp_logger/spark-code/Adafruit_MPL115A2.h
    /Volumes/Repositories/temp_logger/spark-code/dht.h
    /Volumes/Repositories/temp_logger/spark-code/weather.ino
    /Volumes/Repositories/temp_logger/spark-code/Adafruit_MPL115A2.cpp
    /Volumes/Repositories/temp_logger/spark-code/dht.cpp
attempting to compile firmware
pushing file: /Volumes/Repositories/temp_logger/spark-code/Adafruit_MPL115A2.h
pushing file: /Volumes/Repositories/temp_logger/spark-code/dht.h
pushing file: /Volumes/Repositories/temp_logger/spark-code/weather.ino
pushing file: /Volumes/Repositories/temp_logger/spark-code/Adafruit_MPL115A2.cpp
pushing file: /Volumes/Repositories/temp_logger/spark-code/dht.cpp
Memory use:
   text	   data	    bss	    dec	    hex	filename
  87640	   1280	  11960	 100880	  18a10	/spark/compile_server/shared/workspace/3_compile-server2/core-firmware/build/40806d0d186250dc010a43805ccb759d08183f5b9600fef1ade78cc63d88.elf

grabbing binary from: https://api.spark.io/v1/binaries/54dc665fe581a5a66a144ebc
saved firmware to /Volumes/Repositories/temp_logger/firmware_1423730270705.bin
Compiled firmware downloaded.
temp_logger fzurell$ spark flash <your_corename> firmware_1423730270705.bin
 
```