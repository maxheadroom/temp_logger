// This #include statement was automatically added by the Spark IDE.
#include "Adafruit_MPL115A2.h"

// This #include statement was automatically added by the Spark IDE.
#include "dht.h"



// define the internal variables
double temperature = 0;
double pressure = 0;
double humidity = 0;
double dht22temp = 0;
double dewpoint = 0;

// define some limits for the readings
// outside of those limits we assume a sensor problem
int temp_low_limit = -30;
int temp_high_limit = 100;
int pressure_low_limit = 50;
int pressure_high_limit = 170;
int humidity_low_limit = 0;
int humidity_high_limit = 105;

// last reset as epoch
int last_reset = 0;
// 
#define DHTPIN D4
#define DHTTYPE DHT22

//  instantiate the MPL115A2 Sensor
Adafruit_MPL115A2 sensor1;

// initialize DHT22
DHT dht(DHTPIN, DHTTYPE);



void setup() {
    
    Serial.begin(9600);
    Serial.println("Initializing sensors...");
    // initiate the I2C bus
    Wire.begin();
    // initialize DHT22
    dht.begin();
    // register new function with Spark Cloud for the temperature
    Spark.variable("temperature", &temperature, DOUBLE);
    Spark.variable("pressure", &pressure, DOUBLE);
    Spark.variable("humidity", &humidity, DOUBLE);
    Spark.variable("dht22temp", &dht22temp, DOUBLE);
    Spark.variable("dewpoint", &dewpoint, DOUBLE);
	Spark.variable("lastreset", &last_reset, INT);
	// initialze the sensor
    sensor1.begin();
    // enable Serial output
    

}

void loop() {
    
    // read temperature from the sensors
	temperature = sensor1.getTemperature();
	pressure = sensor1.getPressure();
	
	humidity = dht.readHumidity();
    dht22temp = dht.readTemperature();
    dewpoint = dht.dewPoint(dht22temp, humidity);

	if ( temperature < temp_low_limit ) {
		last_reset = Time.now();
	    System.reset();
	  }

}