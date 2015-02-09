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


// 
#define DHTPIN D4
#define DHTTYPE DHT22

//  instantiate the MPL115A2 Sensor
Adafruit_MPL115A2 sensor1;

// initialize DHT22
DHT dht(DHTPIN, DHTTYPE);


// Blink LED and wait for some time
void BlinkLED(){
    digitalWrite(D7, HIGH);   
    delay(500);
    digitalWrite(D7, LOW);   
    delay(500);
    
}


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
    BlinkLED(); 

}