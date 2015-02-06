// This #include statement was automatically added by the Spark IDE.
#include "idDHT22/idDHT22.h"


// This #include statement was automatically added by the Spark IDE.
#include "Adafruit_MPL115A2/Adafruit_MPL115A2.h"






//  instantiate the Sensor
Adafruit_MPL115A2 sensor1;

// define the internal variables
double temp = 0;
double pressure = 0;
double humidity = 0;
double dht22temp = 0;


// declaration for DHT11 handler
int idDHT22pin = A0; //Digital pin for comunications (Analog pin works as well)
void dht22_wrapper(); // must be declared before the lib initialization

// DHT instantiate
idDHT22 DHT22(idDHT22pin, dht22_wrapper);



void setup() {
	// initiate the I2C bus
    Wire.begin();
    
    
    
	// register new function with Spark Cloud for the temperature
    Spark.variable("temp", &temp, DOUBLE);
    Spark.variable("pressure", &pressure, DOUBLE);
    Spark.variable("humidity", &humidity, DOUBLE);
    Spark.variable("dht22temp", &dht22temp, DOUBLE);
	// initialze the sensor
    sensor1.begin();
    
    

}

// This wrapper is in charge of calling
// mus be defined like this for the lib work
void dht22_wrapper() {
	DHT22.isrCallback();
}


void loop() {
    // read temperature from the sensor
	temp = sensor1.getTemperature();
	pressure = sensor1.getPressure();
	
	// start aquiring data from DHT22
	DHT22.acquire();
	// wait until DHT22 is done fetching & calculating the data
	while (DHT22.acquiring())
		;
	
	dht22temp = DHT22.getCelsius();
	humidity = DHT22.getHumidity();
	
}