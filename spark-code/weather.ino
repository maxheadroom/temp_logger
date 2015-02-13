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
int light = 0; 

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

// Tinker Variables
int tinkerDigitalRead(String pin);
int tinkerDigitalWrite(String command);
int tinkerAnalogRead(String pin);
int tinkerAnalogWrite(String command);
// 
#define DHTPIN D4
#define DHTTYPE DHT22
#define LIGHTPIN A0

//  instantiate the MPL115A2 Sensor
Adafruit_MPL115A2 sensor1;

// initialize DHT22
DHT dht(DHTPIN, DHTTYPE);



void setup() {
	
	// Tinker Functions
	Spark.function("digitalread", tinkerDigitalRead);
    Spark.function("digitalwrite", tinkerDigitalWrite);
    Spark.function("analogread", tinkerAnalogRead);
    Spark.function("analogwrite", tinkerAnalogWrite);

    // enable Serial output
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
	Spark.variable("light", &light, INT);
	// initialze the sensor
    sensor1.begin();
    
    
	// Set analog Read Pin 
	pinMode(LIGHTPIN, INPUT);
}

void loop() {
    
    // read temperature & pressure from MPL115A2
	temperature = sensor1.getTemperature();
	pressure = sensor1.getPressure();
	// read DHT22 sensor
	humidity = dht.readHumidity();
    dht22temp = dht.readTemperature();
    dewpoint = dht.dewPoint(dht22temp, humidity);

	// read photoresistor
	light = analogRead(LIGHTPIN);
	
	// reset the Spark Core if temperature from MPL115A2
	// is below reasonable levels
	
	if ( temperature < temp_low_limit ) {
		last_reset = Time.now();
	    System.reset();
	  }
}

int tinkerDigitalRead(String pin) {
    int pinNumber = pin.charAt(1) - '0';
    if (pinNumber< 0 || pinNumber >7) return -1;
    if(pin.startsWith("D")) {
        pinMode(pinNumber, INPUT_PULLDOWN);
        return digitalRead(pinNumber);}
    else if (pin.startsWith("A")){
        pinMode(pinNumber+10, INPUT_PULLDOWN);
        return digitalRead(pinNumber+10);}
    return -2;}

int tinkerDigitalWrite(String command){
    bool value = 0;
    int pinNumber = command.charAt(1) - '0';
    if (pinNumber< 0 || pinNumber >7) return -1;
    if(command.substring(3,7) == "HIGH") value = 1;
    else if(command.substring(3,6) == "LOW") value = 0;
    else return -2;
    if(command.startsWith("D")){
        pinMode(pinNumber, OUTPUT);
        digitalWrite(pinNumber, value);
        return 1;}
    else if(command.startsWith("A")){
        pinMode(pinNumber+10, OUTPUT);
        digitalWrite(pinNumber+10, value);
        return 1;}
    else return -3;}

int tinkerAnalogRead(String pin){
    int pinNumber = pin.charAt(1) - '0';
    if (pinNumber< 0 || pinNumber >7) return -1;
    if(pin.startsWith("D")){
        pinMode(pinNumber, INPUT);
        return analogRead(pinNumber);}
    else if (pin.startsWith("A")){
        pinMode(pinNumber+10, INPUT);
        return analogRead(pinNumber+10);}
    return -2;}

int tinkerAnalogWrite(String command){
    int pinNumber = command.charAt(1) - '0';
    if (pinNumber< 0 || pinNumber >7) return -1;
    String value = command.substring(3);
    if(command.startsWith("D")){
        pinMode(pinNumber, OUTPUT);
        analogWrite(pinNumber, value.toInt());
        return 1;}
    else if(command.startsWith("A")){
        pinMode(pinNumber+10, OUTPUT);
        analogWrite(pinNumber+10, value.toInt());
        return 1;}
    else return -2;}