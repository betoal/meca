#include "Wire.h"

int button1 = 13;
int button2 = 12;
int beeInput = 11;
int beeOutput = 10;
int slave = 50;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  // For the buttons
  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
  Wire.begin();

  // For xbee
}

// Reads the buttons
int oldRes = 0;
void readInput() {
  // Left
  int res = 0;
  res += digitalRead(button1) ? 0b10 : 0;
  res += digitalRead(button2) ? 0b01 : 0;
  if (res != oldRes) {
    Serial.println(res, DEC);
    Wire.beginTransmission(slave);
    Wire.write(res);
    oldRes = res;
    Wire.endTransmission();
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  readInput();

}
