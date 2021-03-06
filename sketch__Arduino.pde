import processing.serial.*;

Serial port;  // Create object from Serial class
int Sensor;   // Pulse sensor data from Arduino
int lf = 10;  // ASCII linefeed


int curr_ibi; // ARBITRARY values in case sensors don't work
int curr_bpm;
int curr_gsr;

float fake_min_ibi = 100; 
float fake_max_ibi = 1000;
int fake_min_bpm = 30;
int fake_max_bpm = 180;
int fake_min_rpm = 0;
int fake_max_rpm = 100;
int fake_min_gsr = 100;
int fake_max_gsr = 2100;

float data_min_ibi = 0;
float data_max_ibi = 0;
int data_min_bpm = 0;
int data_max_bpm = 0;
int data_min_rpm = 0;
int data_max_rpm = 0;
int data_min_gsr = 0;
int data_max_gsr = 0;

void resetMinMax() {
  curr_ibi = 10; // ARBITRARY values in case sensors don't work
  curr_bpm = 80;
  curr_gsr = 200;

  data_min_ibi = Integer.MAX_VALUE;
  data_max_ibi = Integer.MIN_VALUE;
  data_min_bpm = Integer.MAX_VALUE;
  data_max_bpm = Integer.MIN_VALUE;
  data_min_gsr = Integer.MAX_VALUE;
  data_max_gsr = Integer.MIN_VALUE;
}

boolean setupPort() {
  try {
    String portName = Serial.list()[0]; // Port usually seems to be 0, but maybe try 1 or 2 or etc. if it doesn't work?
    port = new Serial(this, portName, 115200);
    port.clear(); // Throw out the first reading, in case we started reading in the middle of a string from the sender.
    port.bufferUntil(lf);
    return true;
  } 
  catch (Exception e) {
    return false;
  }
}

void serialEvent(Serial port) {
  try {
    String data = port.readStringUntil('\n'); // ... read it and store it in data
    data = trim(data); // cut off white space (carriage return)

    if (data.charAt(0) == 'S') { // leading 'S' means Pulse Sensor data packet
      data = data.substring(1);
      Sensor = int(data);
    }
    if (data.charAt(0) == 'B') { // leading 'B' for BPM data
      data = data.substring(1);
      curr_bpm = int(data);
    }
    if (data.charAt(0) == 'Q') { // leading 'Q' means IBI data
      data = data.substring(1);
      curr_ibi = int(data);
    }
    if (data.charAt(0) == 'G') { // leading 'G' means GSR data
      data = data.substring(1);
      curr_gsr = int(data);
    }
    // println(curr_ibi, curr_bpm, curr_gsr);
  } 
  catch(Exception e) {
    //System.out.println(e.toString());
  }
}
